//
//  GraceCompiler.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import LogManager
import SwiftletUtilities

/// Compiles a Grace Program into a `GraceExecutable` that can be run by a `GraceRuntime` instance.
open class GraceCompiler {
    
    // MARK: Static Properties
    /// A shared instance of the `GraceCompiler`
    public static var shared:GraceCompiler = GraceCompiler()
    
    // MARK: - Properties
    /// A list of external `GraceFunctions` registered with the `GraceCompiler`.
    public var externalFunctions:[String:GraceFunction] = [:]
    
    /// The `GraceFunction` calling stack.
    public var functionStack:[GraceFunction] = []
    
    // MARK: - Computed Properties
    /// Returns the current `GraceFunction` being compiled
    public var currentFuction:GraceFunction? {
        if functionStack.count == 0 {
            return nil
        } else {
            let index = functionStack.count - 1
            return functionStack[index]
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameter externalFunctions: A list of external `GraceFunctions` to be registered with the `GraceCompiler`.
    public init(externalFunctions: [String : GraceFunction]) {
        self.externalFunctions = externalFunctions
    }
    
    // MARK: - Functions
    /// Registers an External Function with this `GraceExecutable`.
    /// - Parameters:
    ///   - name: The name of the function.
    ///   - parameterNames: A list of parameter names.
    ///   - parameterTypes: A list of parameter types.
    ///   - returnType: The return type for the function.
    ///   - function: The body of the function to register.
    public func register(name:String, parameterNames:[String] = [], parameterTypes:[GraceVariable.VariableType] = [], returnType:GraceVariable.VariableType = .void, function:@escaping GraceFunction.ExternalFunction) {
        let function = GraceFunction(name: name, parameterNames: parameterNames, parameterTypes: parameterTypes, returnType: returnType, externalFunction: function)
        externalFunctions[name] = function
    }
    
    /// Checks to see if the given function name has already been defined.
    /// - Parameter name: The name of the function that you are checking for.
    /// - Returns: Returns `true` if the function has been defined, else returns `false.`
    public func hasFunction(name:String) -> Bool {
        return externalFunctions.keys.contains(name)
    }
    
    // !!!: Compiler
    /// Compiles the give Grace Program into a `GraceExecutable`.
    /// - Parameter program: The text containing Grace Program.
    /// - Returns: The `GraceExecutable` generated from the input program.
    public func compile(program:String) throws -> GraceExecutable {
        let executable:GraceExecutable = GraceExecutable()
        let tokenizer = GraceTokenizer()
        
        for (key,function) in externalFunctions {
            executable.functions[key] = function
        }
        
        try tokenizer.parse(program)
        functionStack = []
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            
            // Get next keyword
            let keyword = try getNextKeyword(from: tokenizer)
            
            switch keyword {
            case .importKey:
                let library = tokenizer.pop().value
                
                switch library {
                case "StandardLib":
                    ImportStandardLibrary(to: executable)
                case "StringLib":
                    ImportStringLibrary(to: executable)
                case "MacroLib":
                    ImportMacroLibrary(to: executable)
                default:
                    throw GraceCompilerError.unknownLibrary(message: "Unknown library '\(library)' in Import call.")
                }
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
            case .varKey:
                let instruction = GraceVarInstruction()
                instruction.parent = executable
                
                try compileVariableDefinition(tokenizer: tokenizer, executable: executable, variable: instruction)
                
                executable.instructions.append(instruction)
            case .enumerationKey:
                let name = tokenizer.pop().value
                let enumeration = GraceEnumeration(name: name)
                
                enumeration.properties = try compileElementList(tokenizer: tokenizer, executable: executable)
                
                executable.enumerations[name] = enumeration
            case .structureKey:
                let name = tokenizer.pop().value
                let container = GraceContainer(name: name)
                
                let (names, types) = try compileParameterDefineList(tokenizer: tokenizer, executable: executable, forFunction: false)
                container.propertyNames = names
                container.PropertyTypes = types
                
                executable.containers[name] = container
            case .mainKey:
                let mainFunction = GraceFunction(name: "main")
                mainFunction.parent = executable
                pushFunction(mainFunction, into: executable)
                
                mainFunction.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: mainFunction)
                
                popFunction()
            case .functionKey:
                let function = GraceFunction(name: tokenizer.pop().value)
                function.parent = executable
                pushFunction(function, into: executable)
                
                let (names, types) = try compileParameterDefineList(tokenizer: tokenizer, executable: executable)
                for name in names {
                    function.parameterNames.append(name)
                }
                for type in types {
                    function.parameterTypes.append(type)
                }
                
                let nextKey = tokenizer.lookAhead().value
                if nextKey == "returns" {
                    tokenizer.pop()
                    function.returnType = try compileVarType(tokenizer: tokenizer, executable: executable)
                }
                
                function.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: function)
                
                popFunction()
            default:
                // Invalid keyword
                throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found.")
            }
        }
        
        return executable
    }
    
    // !!!: Sub Compilers
    /// Compiles a collection of instructions inside of { }.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - parent: The parent `GraceInstruction`.
    /// - Returns: The collection of `GraceInstructions` that have been assembled.
    private func compileInstructionSet(tokenizer:GraceTokenizer, executable:GraceExecutable, parent:GraceInstruction) throws -> [GraceInstruction] {
        var instructions:[GraceInstruction] = []
        
        // Function must start with an open curly bracket
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openCurlyBracket)
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            
            // Get next keyword
            let keyword = try getNextKeyword(from: tokenizer)
            switch keyword {
            case .varKey:
                let instruction = GraceVarInstruction()
                instruction.parent = parent
                
                try compileVariableDefinition(tokenizer: tokenizer, executable: executable, variable: instruction)
                
                instructions.append(instruction)
            case .letKey:
                let instruction = GraceLetInstruction()
                instruction.executable = executable
                instruction.parent = parent
                
                try compileLetInstruction(tokenizer: tokenizer, executable: executable, for: instruction)
                
                instructions.append(instruction)
            case .callKey:
                let instruction = GraceCallInstruction()
                instruction.executable = executable
                instruction.parent = parent
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .atSymbol)
                
                instruction.functionName = tokenizer.pop().value
                instruction.parameters = try compileParameterCallList(tokenizer: tokenizer, executable: executable, for: instruction)
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
                
                instructions.append(instruction)
            case .incrementKey:
                let instruction = GraceIncrementInstruction()
                instruction.parent = parent
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
                instruction.variableName = tokenizer.pop().value
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
                
                instructions.append(instruction)
            case .decrementKey:
                let instruction = GraceDecrementInstruction()
                instruction.parent = parent
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
                instruction.variableName = tokenizer.pop().value
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
                
                instructions.append(instruction)
            case .addKey:
                let instruction = GraceAddInstruction()
                instruction.parent = parent
                
                try compileAddInstruction(tokenizer: tokenizer, executable: executable, instruction: instruction)
                
                instructions.append(instruction)
            case .deleteKey:
                let instruction = GraceDeleteInstruction()
                instruction.parent = parent
                
                try compileDeleteInstruction(tokenizer: tokenizer, executable: executable, instruction: instruction)
                
                instructions.append(instruction)
            case .emptyKey:
                let instruction = GraceEmptyInstruction()
                instruction.parent = parent
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
                instruction.variableName = tokenizer.pop().value
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
                
                instructions.append(instruction)
            case .iterateKey:
                let instruction = GraceIterateInstruction()
                instruction.parent = parent
                
                instruction.iteratorName = tokenizer.pop().value
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .inKey)
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
                instruction.variableName = tokenizer.pop().value
                instruction.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
                
                instructions.append(instruction)
            case .forKey:
                let instruction = GraceForInstruction()
                instruction.parent = parent
                
                instruction.iteratorName = tokenizer.pop().value
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .inKey)
                instruction.fromExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .toKey)
                instruction.toExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                instruction.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
                
                instructions.append(instruction)
            case .whileKey:
                let instruction = GraceWhileInstruction()
                instruction.parent = parent
                
                instruction.whileExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                instruction.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
                
                instructions.append(instruction)
            case .repeatKey:
                let instruction = GraceRepeatInstruction()
                instruction.parent = parent
                
                instruction.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .untilKey)
                instruction.untilExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                
                instructions.append(instruction)
            case .ifKey:
                let instruction = GraceIfInstruction()
                instruction.parent = parent
                
                try compileIfInstruction(tokenizer: tokenizer, executable: executable, instruction: instruction)
                
                instructions.append(instruction)
            case .switchKey:
                let instruction = GraceSwitchInstruction()
                instruction.parent = parent
                
                try compileSwitchInstruction(tokenizer: tokenizer, executable: executable, instruction: instruction)
                
                instructions.append(instruction)
            case .returnKey:
                let instruction = GraceReturnInstruction()
                instruction.parent = parent
                
                // Allow for not returning a value.
                let nextKey = tokenizer.lookAhead()
                if nextKey.value == ";" {
                    tokenizer.pop()
                } else {
                    instruction.expression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                    try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
                }
                
                instructions.append(instruction)
            case .closedCurlyBracket:
                return instructions
            default:
                // Invalid keyword
                throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found.")
            }
        }
        
        return instructions
    }
    
    /// Assembles a `switch` statement from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    private func compileSwitchInstruction(tokenizer:GraceTokenizer, executable:GraceExecutable, instruction:GraceSwitchInstruction) throws {
        
        instruction.testExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openCurlyBracket)
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            // Get next keyword
            let keyword = try getNextKeyword(from: tokenizer)
            switch keyword {
            case .caseKey:
                let switchCase = GraceCaseStatement()
                
                switchCase.textExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                switchCase.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
                
                instruction.cases.append(switchCase)
            case .defaultKey:
                let switchCase = GraceCaseStatement()
                
                switchCase.instructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
                
                instruction.defaultCase = switchCase
            case .closedCurlyBracket:
                return
            default:
                // Invalid keyword
                throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found.")
            }
        }
    }
    
    /// Assembles an `if-then-else` statement from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    private func compileIfInstruction(tokenizer:GraceTokenizer, executable:GraceExecutable, instruction:GraceIfInstruction) throws {
        
        instruction.testExpressions = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
        instruction.trueInstructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
        
        let nextKey = tokenizer.lookAhead().value
        if nextKey == "else" {
            tokenizer.pop()
            instruction.falseInstructions = try compileInstructionSet(tokenizer: tokenizer, executable: executable, parent: instruction)
        }
    }
    
    /// Assembles a `add` instruction from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    private func compileAddInstruction(tokenizer:GraceTokenizer, executable:GraceExecutable, instruction:GraceAddInstruction) throws {
        
        instruction.expression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .toKey)
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
        
        instruction.variableName = tokenizer.pop().value
        
        let keyword = try getNextKeyword(from: tokenizer)
        switch keyword {
        case .atKey:
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .indexKey)
            instruction.indexExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
        case .semicolon:
            break
        default:
            // Invalid keyword
            throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found.")
        }
    }
    
    /// Assembles a `delete` instruction from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    private func compileDeleteInstruction(tokenizer:GraceTokenizer, executable:GraceExecutable, instruction:GraceDeleteInstruction) throws {
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .indexKey)
        
        instruction.indexExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .fromKey)
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
        
        instruction.variableName = tokenizer.pop().value
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)

    }
    
    /// Assembles a `var` instruction from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - variable: The parent `GraceInstruction`.
    private func compileVariableDefinition(tokenizer:GraceTokenizer, executable:GraceExecutable, variable:GraceVarInstruction) throws {
        var element:GraceToken = GraceToken()
        var keyword:GraceKeyword = .addKey
        
        // Get name.
        element = tokenizer.pop()
        variable.name = element.value
        
        // The next token must be a colon.
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .colon)
        
        // Get type.
        keyword = try getNextKeyword(from: tokenizer)
        switch keyword {
        case .anyKey:
            variable.type = .any
        case .stringKey:
            variable.type = .string
        case .boolKey:
            variable.type = .bool
        case .intKey:
            variable.type = .int
        case .floatKey:
            variable.type = .float
        case .enumerationKey:
            variable.type = .enumeration
            variable.subtypeName = tokenizer.pop().value
        case.structureKey:
            variable.type = .structure
            variable.subtypeName = tokenizer.pop().value
        default:
            // Invalid keyword
            throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found in variable '\(variable.name)' definition.")
        }
        
        // Is an array definition?
        let nextKey = tokenizer.lookAhead().value
        if nextKey == "array" {
            tokenizer.pop()
            variable.isArray = true
        }
        
        // Get type
        keyword = try getNextKeyword(from: tokenizer)
        switch keyword {
        case .semicolon:
            return
        case .equal:
            break
        default:
            // Invalid keyword
            throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found in variable '\(variable.name)' definition.")
        }
        
        // Add initialization
        variable.defaultValue = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: variable)
        
        // The next token must be a semicolon.
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
    }
    
    /// Assembles a `let` instruction from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    private func compileLetInstruction(tokenizer:GraceTokenizer, executable:GraceExecutable, for instruction:GraceLetInstruction) throws {
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .dollarSign)
        
        // Get name
        instruction.variableName = tokenizer.pop().value
        
        let nextToken = tokenizer.lookAhead()
        switch nextToken.value {
        case "~":
            tokenizer.pop()
            instruction.propertyName = tokenizer.pop().value
        case "[":
            tokenizer.pop()
            
            instruction.indexExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
            
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .closedSquareBracket)
        default:
            break
        }
        
        // The next token must be an equal.
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .equal)
        
        // Add initialization
        instruction.expression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
        
        // The next token must be a semicolon.
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .semicolon)
    }
    
    /// Assembles a `GraceExpression` from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    /// - Returns: Returns the assembled `GraceExpression`.
    private func compileExpressionDefinition(tokenizer:GraceTokenizer, executable:GraceExecutable, for instruction:GraceInstruction) throws -> GraceExpression? {
        
        let keyword = try getNextKeyword(from: tokenizer, allowsUnknown: true)
        switch keyword {
        case .dollarSign:
            // Variable dereference
            let expression = GraceVariableExpression()
            expression.parent = instruction
            expression.variableName = tokenizer.pop().value
            
            let nextToken = tokenizer.lookAhead()
            switch nextToken.value {
            case "~":
                tokenizer.pop()
                expression.propertyName = tokenizer.pop().value
            case "[":
                tokenizer.pop()
                
                expression.indexExpression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
                
                try ensureNextElementMatches(tokenizer: tokenizer, keyword: .closedSquareBracket)
            default:
                break
            }
            
            return expression
        case .atSymbol:
            // Function Call
            let expression = GraceFunctionExpression()
            expression.executable = executable
            expression.functionName = tokenizer.pop().value
            expression.parameters = try compileParameterCallList(tokenizer: tokenizer, executable: executable, for: instruction)
            
            return expression
        case .numberSymbol:
            let expression = GraceEnumerationExpression()
            expression.executable = executable
            
            expression.enumerationName = tokenizer.pop().value
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .tilda)
            expression.propertyName = tokenizer.pop().value
            
            return expression
        case .openParenthesis:
            let expression = GraceFormulaExpression()
            expression.leftOperand = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
            expression.operation = tokenizer.pop().value
            expression.rightOperand = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
            
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .closedParenthesis)
            
            return expression
        case .notKey:
            let expression = GraceNotExpression()
            expression.operand = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction)
            
            return expression
        case .newKey:
            let expression = GraceNewExpression()
            expression.executable = executable
            expression.structureName = tokenizer.pop().value
            
            let (names, values) = try compileParameterNewList(tokenizer: tokenizer, executable: executable, for: instruction)
            expression.parameterNames = names
            expression.parameterValues = values
            
            return expression
        case .openSquareBracket:
            let expression = GraceArrayExpression()
            expression.elements = try compileArrayList(tokenizer: tokenizer, executable: executable, for: instruction)
            
            return expression
        case .emptyStringKey:
            return GraceConstantExpression()
        case .trueKey:
            return GraceConstantExpression(value: "true")
        case .falseKey:
            return GraceConstantExpression(value: "false")
        case .nullKey:
            return GraceConstantExpression(value: "null")
        case .voidKey:
            return GraceConstantExpression(value: "void")
        default:
            // Assume constant
            let element = tokenizer.pop()
            return GraceConstantExpression(value: element.value)
        }
    }
    
    /// Assembles the parameter list for a `new` instruction.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    /// - Returns: Returns a collection of assembled `GraceExpressions`.
    private func compileParameterNewList(tokenizer:GraceTokenizer, executable:GraceExecutable, for instruction:GraceInstruction) throws -> ([String], [GraceExpression]) {
        var names:[String] = []
        var values:[GraceExpression] = []
        var forName:Bool = true
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openParenthesis)
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            
            // Get next keyword
            let nextKey = tokenizer.lookAhead().value
            switch nextKey {
            case ":", ",":
                tokenizer.pop()
                break
            case ")":
                tokenizer.pop()
                return (names, values)
            default:
                if forName {
                    names.append(tokenizer.pop().value)
                    forName = false
                } else {
                    if let expression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction) {
                        values.append(expression)
                    }
                    forName = true
                }
            }
        }
        
        return (names, values)
    }
    
    /// Assembles a list of parameter definitions from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    /// - Returns: A dictionary of assembled `GraceVariable.VariableTypes`.
    private func compileParameterDefineList(tokenizer:GraceTokenizer, executable:GraceExecutable, forFunction:Bool = true) throws -> ([String], [GraceVariable.VariableType]) {
        var names:[String] = []
        var types:[GraceVariable.VariableType] = []
        var forName:Bool = true
        var delimiter:String = ")"
        
        if forFunction {
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openParenthesis)
        } else {
            try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openCurlyBracket)
            delimiter = "}"
        }
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            
            // Get next keyword
            let nextKey = tokenizer.lookAhead().value
            switch nextKey {
            case "array", ":", ",":
                tokenizer.pop()
                break
            case delimiter:
                tokenizer.pop()
                return (names, types)
            default:
                if forName {
                    names.append(tokenizer.pop().value)
                    forName = false
                } else {
                    types.append(try compileVarType(tokenizer: tokenizer, executable: executable, forFunction: forFunction))
                    forName = true
                }
            }
        }
        
        return (names, types)
    }
    
    /// Assembles a list of enumeration elements from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    /// - Returns: Returns an array of elements.
    private func compileElementList(tokenizer:GraceTokenizer, executable:GraceExecutable) throws -> [String] {
        var items:[String] = []
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openCurlyBracket)
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            let keyword = try getNextKeyword(from: tokenizer, allowsUnknown: true)
            switch keyword {
            case .comma:
                break
            case .unknown:
                items.append(tokenizer.pop().value)
            case .closedCurlyBracket:
                return items
            default:
                // Invalid keyword
                throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found in enumeration definition.")
            }
        }
        
        return items
    }
    
    /// Assembles a varaible type from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - forFunction: If `true`, were assembling a function definition.
    /// - Returns: Returns the variable type.
    private func compileVarType(tokenizer:GraceTokenizer, executable:GraceExecutable, forFunction:Bool = true) throws -> GraceVariable.VariableType {
        var type:GraceVariable.VariableType = .any
        
        let keyword = try getNextKeyword(from: tokenizer)
        switch keyword {
        case .anyKey:
            type = .any
        case .stringKey:
            type = .string
        case .boolKey:
            type = .bool
        case .intKey:
            type = .int
        case .floatKey:
            type = .float
        case .enumerationKey:
            type = .enumeration
        case.structureKey:
            if forFunction {
                type = .structure
            } else {
                throw GraceCompilerError.invalidParameterType(message: "Parameter/Property type Structure not valid for the current construct.")
            }
        default:
            // Invalid keyword
            throw GraceCompilerError.invalidKeyword(message: "Unexpected keyword `\(keyword)` found in variable definition.")
        }
        
        return type
    }
    
    /// Assembles an array list of items from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    /// - Returns: Returns the assembled `GraceExpressions`.
    private func compileArrayList(tokenizer:GraceTokenizer, executable:GraceExecutable, for instruction:GraceInstruction) throws -> [GraceExpression] {
        var elements:[GraceExpression] = []
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            
            // Get next keyword
            let nextKey = tokenizer.lookAhead().value
            switch nextKey {
            case ",":
                tokenizer.pop()
                break
            case "]":
                tokenizer.pop()
                return elements
            default:
                if let expression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction) {
                    elements.append(expression)
                }
            }
        }
        
        return elements
    }
    
    /// Assembles a parameter call list from the input program.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - executable: The `GraceExecutable` being assembled.
    ///   - instruction: The parent `GraceInstruction`.
    /// - Returns: Returns the assembled `GraceExpressions`.
    private func compileParameterCallList(tokenizer:GraceTokenizer, executable:GraceExecutable, for instruction:GraceInstruction) throws -> [GraceExpression] {
        var parameters:[GraceExpression] = []
        
        try ensureNextElementMatches(tokenizer: tokenizer, keyword: .openParenthesis)
        
        // Interpret parse queue
        while tokenizer.count > 0 {
            
            // Get next keyword
            let nextKey = tokenizer.lookAhead().value
            switch nextKey {
            case ",":
                tokenizer.pop()
                break
            case ")":
                tokenizer.pop()
                return parameters
            default:
                if let expression = try compileExpressionDefinition(tokenizer: tokenizer, executable: executable, for: instruction) {
                    parameters.append(expression)
                }
            }
        }
        
        return parameters
    }
    
    /// Gets the next keyword from the tokenizer.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - allowsUnknown: If `true`, unknown keywords are allowed.
    /// - Returns: Returns the found keyword.
    private func getNextKeyword(from tokenizer:GraceTokenizer, allowsUnknown:Bool = false) throws -> GraceKeyword {
        // Get next keyword
        let element = tokenizer.pop()
        
        // Is this a single or double quoted string?
        switch element.type {
        case .doubleQuotedString, .singleQuotedString:
            // Return token and return unknown
            tokenizer.replace(element: element)
            return .unknown
        default:
            break
        }
        
        if let keyword = GraceKeyword.get(fromString: element.value) {
            return keyword
        } else {
            if allowsUnknown {
                // Return token and return unknown
                tokenizer.replace(element: element)
                return .unknown
            } else {
                // Invalid keyword
                throw GraceCompilerError.invalidKeyword(message: "Invalid keyword `\(element.value)` found.")
            }
        }
    }
    
    /// Ensures the next keyword matches the request.
    /// - Parameters:
    ///   - tokenizer: The `GraceTokenizer` containing the preprocessed program text.
    ///   - keyword: The keyword to match.
    private func ensureNextElementMatches(tokenizer:GraceTokenizer, keyword: GraceKeyword) throws {
        
        let nextKeyword = try getNextKeyword(from: tokenizer)
        if keyword != nextKeyword {
            throw GraceCompilerError.invalidKeyword(message: "Expected `\(keyword.rawValue)` but found `\(nextKeyword.rawValue)`")
        }
    }
    
    /// Pops a `GraceFunction` off of the calling stack.
    /// - Returns: Returns the requested `GraceFunction`.
    @discardableResult public func popFunction() -> GraceFunction {
        let index = functionStack.count - 1
        let value = functionStack[index]
        
        functionStack.remove(at: index)
        
        return value
    }
    
    /// Pushes a `GraceFunction` onto the calling stack.
    /// - Parameters:
    ///   - value: The `GraceFunction` to push.
    ///   - executable: The `GraceExecutable` to push the function into.
    public func pushFunction(_ value:GraceFunction, into executable:GraceExecutable) {
        executable.functions[value.name] = value
        functionStack.append(value)
    }
    
    /// Imports the standard library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    private func ImportStandardLibrary(to executable:GraceExecutable) {
        
        // Add print
        executable.register(name: "print", parameterNames: ["message"], parameterTypes: [.any]) { parameters in
            
            if let message = parameters["message"] {
                Debug.info(subsystem: "Grace Runtime", category: "Print", message.string)
            }
            
            return nil
        }
        
        // Add formatted print
        executable.register(name: "printf", parameterNames: ["text", "elements"], parameterTypes: [.string, .any]) { parameters in
            var result:String = ""
            
            guard let text = parameters["text"] else {
                return GraceVariable.emptyString
            }
            
            guard let elements = parameters["elements"] else {
                return text
            }
            
            result = text.string
            for n in 0..<elements.count {
                result.replace("{\(n)}", with: elements.string(n))
            }
            
            Debug.info(subsystem: "Grace Runtime", category: "Print", result)
            
            return nil
        }
        
        // Add array item count.
        executable.register(name: "count", parameterNames: ["array"], parameterTypes: [.any], returnType: .int) { parameters in
            var length:Int = 0
            
            if let array = parameters["array"] {
                length = array.count
            }
            
            return GraceVariable(name: "result", value: "\(length)", type: .int)
        }
        
        // Add random number generator.
        executable.register(name: "random", parameterNames: ["from", "to"], parameterTypes: [.int, .int], returnType: .int) { parameters in
            var value:Int = 0
            
            if let to = parameters["from"] {
                if let from = parameters["to"] {
                    value = Int.random(in: from.int...to.int)
                }
            }
            
            return GraceVariable(name: "result", value: "\(value)", type: .int)
        }
        
        // Add Array Contains
        executable.register(name: "arrayContains", parameterNames: ["array", "element"], parameterTypes: [.any, .any], returnType: .bool) { parameters in
            var found:Bool = false
            
            if let array = parameters["array"] {
                if let element = parameters["element"] {
                    for n in 0..<array.count {
                        if array.string(n) == element.string {
                            found = true
                            break
                        }
                    }
                }
            }
            
            return GraceVariable(name: "result", value: "\(found)", type: .bool)
        }
    }
    
    /// Imports the string library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    private func ImportStringLibrary(to executable:GraceExecutable) {
        
        // Add format.
        executable.register(name: "format", parameterNames: ["text", "elements"], parameterTypes: [.string, .any], returnType: .string) { parameters in
            var result:String = ""
            
            guard let text = parameters["text"] else {
                return GraceVariable.emptyString
            }
            
            guard let elements = parameters["elements"] else {
                return text
            }
            
            result = text.string
            for n in 0..<elements.count {
                result.replace("{\(n)}", with: elements.string(n))
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add char.
        executable.register(name: "char", parameterNames: ["text", "index"], parameterTypes: [.string, .int], returnType: .string) { parameters in
            var char:String = ""
            
            if let text = parameters["text"] {
                if let index = parameters["index"] {
                    char = "\(text.string[index.int])"
                }
            }
            
            return GraceVariable(name: "result", value: char, type: .string)
        }
        
        // Add length.
        executable.register(name: "length", parameterNames: ["text"], parameterTypes: [.string], returnType: .int) { parameters in
            var length:Int = 0
            
            if let text = parameters["text"] {
                length = text.count
            }
            
            return GraceVariable(name: "result", value: "\(length)", type: .int)
        }
        
        // Add contains.
        executable.register(name: "stringContains", parameterNames: ["text", "pattern"], parameterTypes: [.string, .string], returnType: .bool) { parameters in
            var found:Bool = false
            
            if let text = parameters["text"] {
                if let pattern = parameters["pattern"] {
                    found = text.string.contains(pattern.string)
                }
            }
            
            return GraceVariable(name: "result", value: "\(found)", type: .bool)
        }
        
        // Add replace
        executable.register(name: "replace", parameterNames: ["text", "item", "newValue"], parameterTypes: [.string, .string, .string]) { parameters in
            
            if let text = parameters["text"] {
                if let item = parameters["item"] {
                    if let newValue = parameters["newValue"] {
                        text.string = text.string.replacing(item.string, with: newValue.string)
                    }
                }
            }
            
            return nil
        }
        
        // Add concat
        executable.register(name: "concat", parameterNames: ["text", "item", "delimiter"], parameterTypes: [.string, .string, .string]) { parameters in
            
            if let text = parameters["text"] {
                if let item = parameters["item"] {
                    if let delimiter = parameters["delimiter"] {
                        if text.string == "" {
                            text.string = item.string
                        } else {
                            text.string = "\(text.string)\(delimiter.string)\(item.string)"
                        }
                    }
                }
            }
            
            return nil
        }
        
        // Add upper cased.
        executable.register(name: "uppercase", parameterNames: ["text"], parameterTypes: [.string]) { parameters in
            
            if let text = parameters["text"] {
                text.string = text.string.uppercased()
            }
            
            return nil
        }
        
        // Add lower cased.
        executable.register(name: "lowercase", parameterNames: ["text"], parameterTypes: [.string]) { parameters in
            
            if let text = parameters["text"] {
                text.string = text.string.lowercased()
            }
            
            return nil
        }
        
        // Add title case.
        executable.register(name: "titlecase", parameterNames: ["text"], parameterTypes: [.string]) { parameters in
            
            if let text = parameters["text"] {
                text.string = text.string.titlecased()
            }
            
            return nil
        }
        
        // Add split string.
        executable.register(name: "split", parameterNames: ["text", "pattern"], parameterTypes: [.string, .string], returnType: .string) { parameters in
            var parts:[String] = []
            
            if let text = parameters["text"] {
                if let pattern = parameters["pattern"] {
                    let elements = text.string.split(separator: pattern.string)
                    for element in elements {
                        parts.append("\(element)")
                    }
                }
            }
            
            let result = GraceVariable()
            result.name = "result"
            result.rawValue = parts
            result.type = .string
            result.isArray = true
            
            return result
        }
        
        // Add left string.
        executable.register(name: "leftString", parameterNames: ["text", "length"], parameterTypes: [.string, .int], returnType: .string) { parameters in
            var result:String = ""
            var count:Int = 0
            
            if let text = parameters["text"] {
                if let length = parameters["length"] {
                    for char in text.string {
                        if count >= length.int {
                            break
                        } else {
                            result += "\(char)"
                        }
                        count += 1
                    }
                }
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add right string.
        executable.register(name: "rightString", parameterNames: ["text", "length"], parameterTypes: [.string, .int], returnType: .string) { parameters in
            var result:String = ""
            
            if let text = parameters["text"] {
                let max = text.count - 1
                if let length = parameters["length"] {
                    var min = max - length.int
                    if min < 0 {
                        min = 0
                    }
                    for n in min...max {
                        result += "\(text.string[n])"
                    }
                }
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add mid string.
        executable.register(name: "midString", parameterNames: ["text", "start", "length"], parameterTypes: [.string, .int, .int], returnType: .string) { parameters in
            var result:String = ""
            
            if let text = parameters["text"] {
                if let start = parameters["start"] {
                    if let length = parameters["length"] {
                        var min = start.int
                        if min < 0 {
                            min = 0
                        }
                        
                        var max = min + length.int
                        if max > text.string.count {
                            max = text.string.count
                        }
                        
                        for n in min...max {
                            result += "\(text.string[n])"
                        }
                    }
                }
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
    }
    
    /// Imports the macro library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    private func ImportMacroLibrary(to executable:GraceExecutable) {
        
        // Add `If` function.
        executable.register(name: "if", parameterNames: ["condition", "isTrue", "isFalse"], parameterTypes: [.bool, .any, .any], returnType: .string) { parameters in
            var result:String = ""
            
            if let condition = parameters["condition"] {
                if condition.bool {
                    if let text = parameters["isTrue"] {
                        result = text.string
                    } else {
                        result = "**@IF ERROR**"
                    }
                } else {
                    if let text = parameters["isFalse"] {
                        result = text.string
                    }
                }
            } else {
                result = "**@IF ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `randomString` function.
        executable.register(name: "randomString", parameterNames: ["items"], parameterTypes: [.string], returnType: .string) { parameters in
            var result:String = ""
            
            if let items = parameters["items"] {
                let index = Int.random(in: 0..<items.count)
                result = items.string(index)
            } else {
                result = "**@RANDOMSTRING ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `selectString` function.
        executable.register(name: "selectString", parameterNames: ["part", "items"], parameterTypes: [.int ,.string], returnType: .string) { parameters in
            var result:String = ""
            
            if let part = parameters["part"] {
                if let items = parameters["items"] {
                    var index = part.int
                    if index < 0 || index >= items.count {
                        index = 0
                    }
                    result = items.string(index)
                } else {
                    result = "**@SELECTSTRING ERROR**"
                }
            } else {
                result = "**@SELECTSTRING ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `intMath` function.
        executable.register(name: "intMath", parameterNames: ["operandA", "operation", "operandB"], parameterTypes: [.int, .string, .int], returnType: .int) { parameters in
            let result:GraceVariable = GraceVariable(name: "result", value: "0", type: .int)
            
            if let operandA = parameters["operandA"] {
                if let operation = parameters["operation"] {
                    if let operandB = parameters["operandB"] {
                        switch operation.string {
                        case "+":
                            result.int = operandA.int + operandB.int
                        case "-":
                            result.int = operandA.int - operandB.int
                        case "*":
                            result.int = operandA.int * operandB.int
                        case "/":
                            result.int = operandA.int / operandB.int
                        default:
                            result.string = "**@INTMATH ERROR: \(operation.string)**"
                        }
                    } else {
                        result.string = "**@INTMATH ERROR: operandB**"
                    }
                } else {
                    result.string = "**@INTMATH ERROR: operation**"
                }
            } else {
                result.string = "**@INTMATH ERROR: operandA**"
            }
            
            return result
        }
        
        // Add `intMath` function.
        executable.register(name: "floatMath", parameterNames: ["operandA", "operation", "operandB"], parameterTypes: [.float, .string, .float], returnType: .float) { parameters in
            let result:GraceVariable = GraceVariable(name: "result", value: "0", type: .float)
            
            if let operandA = parameters["operandA"] {
                if let operation = parameters["operation"] {
                    if let operandB = parameters["operandB"] {
                        switch operation.string {
                        case "+":
                            result.float = operandA.float + operandB.float
                        case "-":
                            result.float = operandA.float - operandB.float
                        case "*":
                            result.float = operandA.float * operandB.float
                        case "/":
                            result.float = operandA.float / operandB.float
                        default:
                            result.string = "**@INTMATH ERROR: \(operation)**"
                        }
                    } else {
                        result.string = "**@INTMATH ERROR: operandB**"
                    }
                } else {
                    result.string = "**@INTMATH ERROR: operation**"
                }
            } else {
                result.string = "**@INTMATH ERROR: operandA**"
            }
            
            return result
        }
        
        // Add `formatFloat` function.
        executable.register(name: "formatFloat", parameterNames: ["number"], parameterTypes: [.float], returnType: .float) { parameters in
            var result:String = ""
            
            if let number = parameters["number"] {
                let value = number.float
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let formattedNumber = numberFormatter.string(from: NSNumber(value:value)) {
                    result = formattedNumber
                } else {
                    result = "**@FORMATFLOAT ERROR**"
                }
            } else {
                result = "**@FORMATFLOAT ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `expandMacros` function.
        executable.register(name: "expandMacros", parameterNames: ["text"], parameterTypes: [.string], returnType: .string) { parameters in
            var result:String = ""
            
            if let text = parameters["text"] {
                do {
                    result = try GraceRuntime.shared.expandMacros(in: text.string)
                } catch {
                    result = "**@EXPANDMACROS ERROR: \(error)**"
                }
            } else {
                result = "**@EXPANDMACROS ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
    }
}

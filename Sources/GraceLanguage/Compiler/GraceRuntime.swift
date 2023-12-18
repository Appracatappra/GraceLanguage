//
//  GraceRuntime.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/27/23.
//

import Foundation
import SwiftletUtilities

/// Runs a Grace Program.
open class GraceRuntime {
    
    // MARK: - Static Properties
    /// A common shared instance of the Grace Runtime.
    public static var shared:GraceRuntime = GraceRuntime()
    
    // MARK: - Static Functions
    /// Gets a `GraceVariable` from the given `GraceInstruction`.
    /// - Parameters:
    ///   - name: The name of the variable to get.
    ///   - container: The `GraceInstruction` holding the variable.
    /// - Returns: Returns the requested variable of `nil` if not found.
    public static func getVariable(name:String, from container:GraceInstruction) -> GraceVariable? {
        
        if container.variables.keys.contains(name) {
            return container.variables[name]
        } else if let parent = container.parent {
            return getVariable(name: name, from: parent)
        }
        
        // Not found
        return nil
    }
    
    /// Gets a `GraceFunction` from the given `GraceInstruction`.
    /// - Parameters:
    ///   - name: The name of the function to get.
    ///   - container: The `GraceInstruction` holding the function.
    /// - Returns: Returns the requested function of `nil` if not found.
    public static func getFunction(name:String, from executable:GraceExecutable?) throws -> GraceFunction {
        if let executable {
            if let function = executable.functions[name] {
                return function
            } else {
                throw GraceRuntimeError.unknownFunction(message: "Function '\(name)' not found.")
            }
        } else {
            throw GraceRuntimeError.unknownFunction(message: "Function '\(name)' not found.")
        }
    }
    
    /// Gets a `GraceEnumeration` from the given `GraceInstruction`.
    /// - Parameters:
    ///   - name: The name of the enumeration to get.
    ///   - container: The `GraceInstruction` holding the function.
    /// - Returns: Returns the requested enumeration of `nil` if not found.
    public static func getEnumeration(name:String, from executable:GraceExecutable?) throws -> GraceEnumeration {
        if let executable {
            if let enumeration = executable.enumerations[name] {
                return enumeration
            } else {
                throw GraceRuntimeError.unknownEnumeration(message: "Enumeration '\(name)' not found.")
            }
        } else {
            throw GraceRuntimeError.unknownEnumeration(message: "Enumeration '\(name)' not found.")
        }
    }
    
    /// Gets a `GraceContainer` from the given `GraceInstruction`.
    /// - Parameters:
    ///   - name: The name of the container to get.
    ///   - container: The `GraceInstruction` holding the function.
    /// - Returns: Returns the requested container of `nil` if not found.
    public static func getContainer(name:String, from executable:GraceExecutable?) throws -> GraceContainer {
        if let executable {
            if let container = executable.containers[name] {
                return container
            } else {
                throw GraceRuntimeError.unknownStructure(message: "Structure '\(name)' not found.")
            }
        } else {
            throw GraceRuntimeError.unknownStructure(message: "Structure '\(name)' not found.")
        }
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    // MARK: - Functions
    /// Runs the given `GraceExecutable`.
    /// - Parameter executable: The executable to run.
    /// - Returns: Returns the results of the execution as a `GraceVariable` or `nil` if nothing is returned.
    @discardableResult public func run(executable:GraceExecutable) throws -> GraceVariable? {
        var result:GraceVariable? = nil
        
        // Get the main function and run it
        let main = try GraceRuntime.getFunction(name: "main", from: executable)
        result = try main.execute()
        
        return result
    }
    
    /// Compiles and runs the given Grace Program.
    /// - Parameter program: The text of the GraceProgram.
    /// - Returns: Returns the results of the execution as a `GraceVariable` or `nil` if nothing is returned.
    @discardableResult public func run(program:String) throws -> GraceVariable? {
        var result:GraceVariable? = nil
        
        // Compile program
        let executable = try GraceCompiler.shared.compile(program: program)
        
        // Get the main function and run it
        let main = try GraceRuntime.getFunction(name: "main", from: executable)
        result = try main.execute()
        
        return result
    }
    
    /// Compiles and runs a snippit of Grace Program code.
    /// - Parameter script: The text of the snipit that does not contain a `main` definition. This code will automatically be wrapped in a generated `main`definition.
    /// - Returns: Returns the results of the execution as a `GraceVariable` or `nil` if nothing is returned.
    @discardableResult public func run(script:String) throws -> GraceVariable? {
        let program:String = "import StandardLib; import StringLib; import MacroLib; main{\(script);}"
        
        return try run(program: program)
    }
    
    /// Complies and runs a snipit of Grace Program code and returns the result of the execution.
    /// - Parameter script: The text of the snipit that does not contain a `main` or `return` definition. This code will automatically be wrapped in a generated `main` and `return`.
    /// - Returns: Returns the results of the execution as a `GraceVariable` or `nil` if nothing is returned.
    @discardableResult public func evaluate(script:String) throws -> GraceVariable? {
        let program:String = "import StandardLib; import StringLib; import MacroLib; main{return \(script);}"
        
        return try run(program: program)
    }
    
    /// Expands any macros written as Grace Function Calls in the given string and inserts the result of executing the function into the output string.
    ///
    /// For Example:
    /// ```
    /// let text = GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
    /// ```
    ///
    /// - Parameter text: The text containing possible Grace Function Calls macros.
    /// - Returns: The text will all macros expanded or the input text if the string contained no marcos.
    public func expandMacros(in text:String) throws -> String {
        var result:String = ""
        var lastCharacter:String = ""
        var inFunction:Bool = false
        var nestLevel:Int = 0
        var function:String = ""
        
        // Ensure there is a potential of a Grace Function call.
        guard text.contains("@") else {
            return text
        }
        
        // Process all characters to expand any possible Grace function calls.
        for char in text {
            let character = "\(char)"
            
            if inFunction {
                switch character {
                case "@":
                    if lastCharacter == "@" {
                        result += character
                        function = ""
                        inFunction = false
                    } else {
                        function += character
                    }
                case "(":
                    nestLevel += 1
                    function += character
                case ")":
                    nestLevel -= 1
                    function += character
                    
                    if nestLevel == 0 {
                        // Execute the Grace function and write the results to the string.
                        if let output = try evaluate(script: function) {
                            result += output.string
                        } else {
                            result += function
                        }
                        
                        function = ""
                        inFunction = false
                    }
                default:
                    function += character
                }
            } else {
                switch character {
                case "@":
                    inFunction = true
                    function += character
                default:
                    result += character
                }
            }
            
            lastCharacter = character
        }
        
        // Handle any remaining functions
        if function != "" {
            // Execute the Grace function and write the results to the string.
            if let output = try evaluate(script: function) {
                result += output.string
            } else {
                result += function
            }
        }
        
        return result
    }
}

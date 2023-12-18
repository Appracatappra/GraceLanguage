//
//  GraceExecutable.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Holds a `GraceExecutable` generated by a `GraceCompiler`.
open class GraceExecutable:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` for this executable.
    public var parent:GraceInstruction? = nil
    
    /// A collection of global `GraceVariables`.
    public var variables:GraceContainer.GraceStructure = [:]
    
    /// A collection of `GraceStructure` prototypes.
    public var containers:[String:GraceContainer] = [:]
    
    /// A collection of `GraceEnumerations`.
    public var enumerations:[String:GraceEnumeration] = [:]
    
    /// A collection of `GraceFunctions`.
    public var functions:[String:GraceFunction] = [:]
    
    /// A collection of global `GraceInstructions`.
    public var instructions:[GraceInstruction] = []
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` holding the results to return to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` for this executable.
    ///   - variables: A collection of global `GraceVariables`.
    ///   - containers: A collection of `GraceStructure` prototypes.
    ///   - functions: A collection of `GraceFunctions`.
    ///   - instructions: A collection of global `GraceInstructions`.
    public init(parent: GraceInstruction? = nil, variables: GraceContainer.GraceStructure = [:], containers: [String : GraceContainer] = [:], functions: [String : GraceFunction] = [:], instructions: [GraceInstruction] = []) {
        self.parent = parent
        self.variables = variables
        self.containers = containers
        self.functions = functions
        self.instructions = instructions
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
        functions[name] = function
    }
    
    /// Checks to see if the given function name has already been defined.
    /// - Parameter name: The name of the function that you are checking for.
    /// - Returns: Returns `true` if the function has been defined, else returns `false.`
    public func hasFunction(name:String) -> Bool {
        return functions.keys.contains(name)
    }
    
    /// Executes the `GraceInstructions` in the `GraceExecutable`.
    /// - Returns: Returns the results of the executipn.
    public func execute() throws -> GraceVariable? {
        
        shouldAbort = false
        returnResult = nil
        for instruction in instructions {
            try instruction.execute()
            if shouldAbort {
                break
            }
        }
        
        return returnResult
    }
}

//
//  GraceFunction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Contains the definition of a `GraceFunction`. Function can be written in Grace or an extern function created via a `register` command.
open class GraceFunction:GraceInstruction, GraceAbortable {
    /// Defines the type of an external function created via a `register` command.
    public typealias ExternalFunction = (GraceContainer.GraceStructure) -> GraceVariable?
    
    // MARK: - Properties
    /// The parent `GraceInstruction` for this function.
    public var parent:GraceInstruction? = nil
    
    /// The name of the function.
    public var name:String = ""
    
    /// A list of parameter names.
    public var parameterNames:[String] = []
    
    /// A list of parameter types.
    public var parameterTypes:[GraceVariable.VariableType] = []
    
    /// The `GraceVariables` that belong to this function.
    public var variables:GraceContainer.GraceStructure = [:]
    
    /// The list of `GraceInstruction` that this function will execute.
    public var instructions:[GraceInstruction] = []
    
    /// Holds the definition of an external function.
    public var externalFunction:ExternalFunction? = nil
    
    /// Defines the return type for the function.
    public var returnType:GraceVariable.VariableType = .void
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` that holds the value returned to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` for this function.
    ///   - name: The name of the function.
    ///   - parameterNames: A list of parameter names.
    ///   - parameterTypes: A list of parameter types.
    ///   - returnType: Defines the return type for the function.
    ///   - externalFunction: Holds the definition of an external function.
    public init(parent: GraceInstruction? = nil, name: String, parameterNames: [String] = [], parameterTypes: [GraceVariable.VariableType] = [], returnType: GraceVariable.VariableType = .void, externalFunction: ExternalFunction? = nil) {
        self.parent = parent
        self.name = name
        self.parameterNames = parameterNames
        self.parameterTypes = parameterTypes
        self.externalFunction = externalFunction
        self.returnType = returnType
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` for this function.
    ///   - name: The name of the function.
    ///   - parameterNames: A list of parameter names.
    ///   - parameterTypes: A list of parameter types.
    ///   - instructions: The list of instruction to execute.
    ///   - externalFunction: Holds the definition of an external function.
    ///   - returnType: The return type.
    public init(parent: GraceInstruction? = nil, name: String, parameterNames: [String], parameterTypes: [GraceVariable.VariableType], instructions: [GraceInstruction], externalFunction: ExternalFunction? = nil, returnType: GraceVariable.VariableType) {
        self.parent = parent
        self.name = name
        self.parameterNames = parameterNames
        self.parameterTypes = parameterTypes
        self.instructions = instructions
        self.externalFunction = externalFunction
        self.returnType = returnType
    }
    
    // MARK: - Functions
    /// Executes the function.
    /// - Returns: Returns the function result to the caller.
    public func execute() throws -> GraceVariable? {
        
        if let externalFunction {
            return externalFunction(variables)
        } else {
            shouldAbort = false
            returnResult = nil
            for instruction in instructions {
                try instruction.execute()
                if shouldAbort {
                    break
                }
            }
        }
        
        return returnResult
    }
}

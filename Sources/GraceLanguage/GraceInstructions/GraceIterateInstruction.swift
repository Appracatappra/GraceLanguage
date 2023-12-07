//
//  GraceIterateInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/28/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Iterates over all items in a given `GraceArray`. Specify the name of a new `GraceVariable` to hold the current item from the array.
///
/// For example:
/// ```
/// import StandardLib;
/// 
/// main {
/// var colors:string array = ["red", "yellow", "green"];
///
/// iterate color in $colors {
/// call @printf("Color is {0}", [$color]);
/// }
///
/// }
/// ```
open class GraceIterateInstruction:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the new `GraceVariable` that will be loaded with the current item.
    public var iteratorName:String = ""
    
    /// The name of the `GraceArray` to iterate over.
    public var variableName:String = ""
    
    /// A collection of `GraceInstructions` that will be run on each iteration.
    public var instructions:[GraceInstruction] = []
    
    /// If `true` stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` holding the result that will be returned to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - iteratorName: The name of the new `GraceVariable` that will be loaded with the current item.
    ///   - variableName: The name of the `GraceArray` to iterate over.
    public init(parent: GraceInstruction? = nil, iteratorName: String, variableName: String) {
        self.parent = parent
        self.iteratorName = iteratorName
        self.variableName = variableName
    }
    
    // MARK: - Functions
    /// Executes the instruction by iterating over all the items in the given `GraceArray` and running the given `GraceInstructions`.
    /// - Returns: Returns the `GraceArray` being iterated over.
    public func execute() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        
        if let parent {
            variable = GraceRuntime.getVariable(name: variableName, from: parent)
        }
        
        if let variable {
            let iterator = GraceVariable(name: iteratorName, rawValue: [""], type: variable.type, isArray: false, subtypeName: variable.subtypeName)
            variables[iteratorName] = iterator
            
            shouldAbort = false
            returnResult = nil
            for value in variable.rawValue {
                iterator.rawValue = [value]
                for instruction in instructions {
                    try instruction.execute()
                    if shouldAbort {
                        return variable
                    }
                }
            }
            
            variables = [:]
        } else {
            throw GraceRuntimeError.unknownVariable(message: "Variable `\(variableName)` not found.")
        }
        
        return variable
    }
}

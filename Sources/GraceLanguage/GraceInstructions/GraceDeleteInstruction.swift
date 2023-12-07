//
//  GraceDeleteInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/28/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Removes a value from a `GraceArray` at the given location.
///
/// For example:
/// ```
/// main {
/// var colors:string array = ["red", "yellow", "green"];
///
/// delete index 2 from $colors;
/// }
/// ```
open class GraceDeleteInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceArray` being modified.
    public var variableName:String = ""
    
    /// The index of the element to remove from the array.
    public var indexExpression:GraceExpression? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - variableName: The name of the `GraceArray` being modified.
    ///   - index: The index of the element to remove from the array.
    public init(parent: GraceInstruction? = nil, variableName: String, index: GraceExpression? = nil) {
        self.parent = parent
        self.variableName = variableName
        self.indexExpression = index
    }
    
    // MARK: - Functions
    /// Executes the instruction and removes the given element from the `GraceArray`.
    /// - Returns: Returns the `GraceArray` being modified.
    public func execute() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        var index:Int = 0
        
        if let parent {
            variable = GraceRuntime.getVariable(name: variableName, from: parent)
        }
        
        if let indexExpression {
            if let value = try indexExpression.evaluate() {
                index = value.int
            }
        }
        
        if let variable {
            if index < 0 || index >= variable.count {
                throw GraceRuntimeError.unknownVariable(message: "Index `\(index)` out of range for variable `\(variableName)`.")
            } else {
                variable.rawValue.remove(at: index)
            }
            variable.isArray = true
        } else {
            throw GraceRuntimeError.unknownVariable(message: "Variable `\(variableName)` not found.")
        }
        
        return variable
    }
    
}

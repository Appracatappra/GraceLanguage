//
//  GraceAddInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/27/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// A  `GraceAddInstruction` adds a new value to a `GraceArray` optionally inserting it into a specific location in the array.
///
/// For example:
/// ```
/// main {
/// var colors:string array = ["red", "yellow", "green"];
///
/// add "lime" to $colors;
/// add "pink" to $colors at index 2;
/// }
/// ```
open class GraceAddInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The value to add to the array.
    public var expression:GraceExpression? = nil
    
    /// The name of the `GraceArray` to modify.
    public var variableName:String = ""
    
    /// The options index to insert the new value at.
    public var indexExpression:GraceExpression? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - expression: The value to add to the array.
    ///   - variableName: The name of the `GraceArray` to modify.
    ///   - index: The options index to insert the new value at.
    public init(parent: GraceInstruction? = nil, expression: GraceExpression? = nil, variableName: String, index: GraceExpression? = nil) {
        self.parent = parent
        self.expression = expression
        self.variableName = variableName
        self.indexExpression = index
    }
    
    // MARK: - Functions
    /// Executes the instruction to modify the given `GraceArray`.
    /// - Returns: Returns the `GraceArray` that was modified.
    public func execute() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        var index:Int = -1
        
        guard let value = try expression?.evaluate() else {
            throw GraceRuntimeError.variableError(message: "Unable to evaluate expression to change variable `\(variableName)`.")
        }
        
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
                variable.rawValue.append(value.string)
            } else {
                variable.rawValue.insert(value.string, at: index)
            }
            variable.isArray = true
        } else {
            throw GraceRuntimeError.unknownVariable(message: "Variable `\(variableName)` not found.")
        }
        
        return variable
    }
    
    
}

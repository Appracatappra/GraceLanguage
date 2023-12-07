//
//  GraceEmptyInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/28/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Removes all elements from a `GraceArray`.
///
/// For example:
/// ```
/// main {
/// var colors:string array = ["red", "yellow", "green"];
///
/// empty $colors;
/// }
/// ```
open class GraceEmptyInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceArray` to empty.
    public var variableName:String = ""
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - variableName: The name of the `GraceArray` to empty.
    public init(parent: GraceInstruction? = nil, variableName: String) {
        self.parent = parent
        self.variableName = variableName
    }
    
    // MARK: - Functions
    /// Executes the instruction and empties the `GraceArray`.
    /// - Returns: Returns the `GraceArray` being modified.
    public func execute() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        
        if let parent {
            variable = GraceRuntime.getVariable(name: variableName, from: parent)
        }
        
        if let variable {
            variable.rawValue = [""]
        } else {
            throw GraceRuntimeError.unknownVariable(message: "Variable `\(variableName)` not found.")
        }
        
        return variable
    }
    
}

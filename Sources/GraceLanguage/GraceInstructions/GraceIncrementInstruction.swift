//
//  GraceIncrementInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/30/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Increments a `GraceVariable` of type `int` or `float` by `1`.
///
/// For Example:
/// ```
/// main {
/// var n:int = 1;
/// increment $n;
/// }
/// ```
open class GraceIncrementInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceVariable` to increment.
    public var variableName:String = ""
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - variableName: The name of the `GraceVariable` to increment.
    public init(parent: GraceInstruction? = nil, variableName: String) {
        self.parent = parent
        self.variableName = variableName
    }
    
    // MARK: - Functions
    /// Executes the instruction and increments the given variable.
    /// - Returns: Returns `nil`.
    public func execute() throws -> GraceVariable? {
        
        guard let parent else {
            throw GraceRuntimeError.unknownVariable(message: "Unknown variable `\(variableName)`.")
        }
        
        guard let variable = GraceRuntime.getVariable(name: variableName, from: parent) else {
            throw GraceRuntimeError.unknownVariable(message: "Unknown variable `\(variableName)`.")
        }
        
        variable.int = variable.int + 1
        
        return nil
    }
}

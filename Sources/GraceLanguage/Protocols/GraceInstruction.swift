//
//  GraceInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/23/23.
//

import Foundation

/// Defines a `GraceInstruction` type.
public protocol GraceInstruction {
    
    /// The parent `GraceInstruction`.
    var parent:GraceInstruction? {get set}
    
    /// A list of `GraceVaraibles`.
    var variables:GraceContainer.GraceStructure { get set }
    
    /// Executes the `GraceInstruction`.
    /// - Returns: The result of the execution.
    @discardableResult func execute() throws -> GraceVariable?
}

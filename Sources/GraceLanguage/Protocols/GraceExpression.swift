//
//  GraceExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/23/23.
//

import Foundation

/// Holds information about a expression parsed from a Grace instruction.
public protocol GraceExpression {
    
    /// Provides access to the executable where this object if defined.
    var coreExe:GraceExecutable? { get set }
    
    /// Executes the `GraceExpression`.
    /// - Returns: The result of the execution.
    @discardableResult func evaluate() throws -> GraceVariable?
    
}

//
//  GraceExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/23/23.
//

import Foundation

/// Holds information about a expression parsed from a Grace instruction.
public protocol GraceExpression {
    
    /// Executes the `GraceExpression`.
    /// - Returns: The result of the execution.
    @discardableResult func evaluate() throws -> GraceVariable?
    
}

//
//  GraceCaseStatement.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/29/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Holds the condition and `GraceInstructions` that will be executed when the condition is met for a Grace `switch` statement.
open class GraceCaseStatement {
    
    // MARK: - Properties
    /// The condition to be met.
    public var textExpression:GraceExpression? = nil
    
    /// The list of `GraceInstructions`.
    public var instructions:[GraceInstruction] = []
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - textExpression: The condition to be met.
    ///   - instructions: The list of `GraceInstructions`.
    public init(textExpression: GraceExpression? = nil, instructions: [GraceInstruction] = []) {
        self.textExpression = textExpression
        self.instructions = instructions
    }
}

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
    
    /// Provides access to the executable where this object if defined.
    public weak var coreExe:GraceExecutable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - textExpression: The condition to be met.
    ///   - instructions: The list of `GraceInstructions`.
    ///   - exe: The parent exe for this object.
    public init(exe:GraceExecutable, textExpression: GraceExpression? = nil, instructions: [GraceInstruction] = []) {
        self.coreExe = exe
        self.textExpression = textExpression
        self.instructions = instructions
    }
}

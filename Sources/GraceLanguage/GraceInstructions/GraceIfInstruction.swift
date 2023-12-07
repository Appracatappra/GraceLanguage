//
//  GraceIfInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/29/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Takes action based on a boolean evaluation.
///
/// For example:
/// ```
/// import StandardLib;
///
/// main {
/// var found:bool = true;
///
/// if $found {
/// call @print("Found");
/// } else {
/// call @print("Not found");
/// }
///
/// }
/// ```
open class GraceIfInstruction:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The boolean evaluation.
    public var testExpressions:GraceExpression? = nil
    
    /// The `GraceInstructions` to execute when the expression is `true`.
    public var trueInstructions:[GraceInstruction] = []
    
    /// The `GraceInstructions` to execute when the expression is `false`.
    public var falseInstructions:[GraceInstruction] = []
    
    /// If `true`, stop executing `GraceInstrcutions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` holding the value to return to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initilaizers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - testExpressions: The boolean evaluation.
    ///   - trueInstructions: The `GraceInstructions` to execute when the expression is `true`.
    ///   - falseInstructions: The `GraceInstructions` to execute when the expression is `false`.
    public init(parent: GraceInstruction? = nil, testExpressions: GraceExpression? = nil, trueInstructions: [GraceInstruction] = [], falseInstructions: [GraceInstruction] = []) {
        self.parent = parent
        self.testExpressions = testExpressions
        self.trueInstructions = trueInstructions
        self.falseInstructions = falseInstructions
    }
    
    // MARK: - Function
    /// Execute the instruction and run a given set of `GraceInstructions` based on a given condition.
    /// - Returns: Returns the result of the execution.
    public func execute() throws -> GraceVariable? {
        
        guard let value = try testExpressions?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Unable to evaluate the test forumla for an If statement.")
        }
        
        shouldAbort = false
        returnResult = nil
        if value.bool {
            for instruction in trueInstructions {
                try instruction.execute()
                if shouldAbort {
                    break
                }
            }
        } else {
            for instruction in falseInstructions {
                try instruction.execute()
                if shouldAbort {
                    break
                }
            }
        }
        
        return returnResult
    }
    
    
}

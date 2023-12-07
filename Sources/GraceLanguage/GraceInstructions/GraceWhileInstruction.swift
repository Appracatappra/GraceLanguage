//
//  GraceWhileInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/28/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// While a condition exists, execute a list of `GraceInstructions`
///
///For example:
/// ```
/// import StandardLib;
///
/// main {
/// var n:int;
///
/// while ($n < 5) {
/// call @printf("n = {0}", [$n]);
/// increment $n;
/// }
///
/// }
/// ```
open class GraceWhileInstruction:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` for this instruction.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The expression to evaluate. If `true` the loop will continue.
    public var whileExpression:GraceExpression? = nil
    
    /// The list of `GraceInstructions` to execute.
    public var instructions:[GraceInstruction] = []
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` holding the result to return to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` for this instruction.
    ///   - whileExpression: The expression to evaluate. If `true` the loop will continue.
    public init(parent: GraceInstruction? = nil, whileExpression: GraceExpression? = nil) {
        self.parent = parent
        self.whileExpression = whileExpression
    }
    
    // MARK: - Functions
    /// Executes the instruction and executes the given `GraceInstruction` while the condition is met.
    /// - Returns: Returns the result of the execution.
    public func execute() throws -> GraceVariable? {
        var loop:Bool = true
        
        repeat {
            if let value = try whileExpression?.evaluate() {
                loop = value.bool
                if loop {
                    shouldAbort = false
                    returnResult = nil
                    for instruction in instructions {
                        try instruction.execute()
                        if shouldAbort {
                            return nil
                        }
                    }
                }
            } else {
                throw GraceRuntimeError.formulaError(message: "Unable to evaluate While expression.")
            }
        } while loop
        
        return returnResult
    }
}

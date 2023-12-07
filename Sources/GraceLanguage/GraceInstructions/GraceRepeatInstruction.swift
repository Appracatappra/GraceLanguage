//
//  GraceRepeatInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/28/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Executes a list of `Graceinstructions` until a condition is met.
///
/// For example:
/// ```
/// import StandardLib;
///
/// main {
/// var n:int;
///
/// repeat {
/// call @printf("N is {0}", [$n]);
/// increment $n
/// } until ($n >= 5);
///
/// }
/// ```
open class GraceRepeatInstruction:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` that this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The condition that must be met to end the loop.
    public var untilExpression:GraceExpression? = nil
    
    /// The list of `GraceInstructions` that will be executed.
    public var instructions:[GraceInstruction] = []
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A`GraceVariable` holding the value to return to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` that this instruction belongs to.
    ///   - untilExpression: The condition that must be met to end the loop.
    public init(parent: GraceInstruction? = nil, untilExpression: GraceExpression? = nil) {
        self.parent = parent
        self.untilExpression = untilExpression
    }
    
    // MARK: - Functions
    /// Executes the instruction running the give list of `GraceInstructions` until the condition is met.
    /// - Returns: Returns the results of the execution to the caller.
    public func execute() throws -> GraceVariable? {
        var loop:Bool = true
        
        repeat {
            shouldAbort = false
            returnResult = nil
            for instruction in instructions {
                try instruction.execute()
                if shouldAbort {
                    break
                }
            }
            
            if let value = try untilExpression?.evaluate() {
                loop = value.bool
            } else {
                throw GraceRuntimeError.formulaError(message: "Unable to evaluate While expression.")
            }
        } while !loop
        
        return returnResult
    }
}

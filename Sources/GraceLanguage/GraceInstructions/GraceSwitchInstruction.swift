//
//  GraceSwitchInstruct.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/29/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Takes action based on a given condition matching one of the cases in the `Switch` or executes a `Default` set of `GraceInstruction` if no condition is met.
///
/// For Example:
/// ```
/// import StandardLib;
///
/// main {
/// var color:string = "red";
///
/// switch $color {
/// case "red" {
/// call @print("Red");
/// }
/// case "yellow" {
/// call @print("Yellow");
/// }
/// case "green" {
/// call @print("Green");
/// }
/// default {
/// call @print("Unknown Color");
/// }
/// }
/// ```
open class GraceSwitchInstruction:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The condition being tested.
    public var testExpression:GraceExpression? = nil
    
    /// A collection of `GraceCaseStatements` that hold the conditions and the `GraceInstructions` that will be executed if the condition is met.
    public var cases:[GraceCaseStatement] = []
    
    /// The defaults `GraceInstrucctions` that will be executed if no condition is met.
    public var defaultCase:GraceCaseStatement? = nil
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` that holds the value to return to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - testExpression: The condition being tested.
    ///   - defaultCase: The defaults `GraceInstrucctions` that will be executed if no condition is met.
    public init(parent: GraceInstruction? = nil, testExpression: GraceExpression? = nil, defaultCase: GraceCaseStatement? = nil) {
        self.parent = parent
        self.testExpression = testExpression
        self.defaultCase = defaultCase
    }
    
    // MARK: - Functions
    /// Executes the instuction taking action based on a condition being met.
    /// - Returns: Returns the result of the execution.
    public func execute() throws -> GraceVariable? {
        
        guard let testValue = try testExpression?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Unable to evaluate an expression for a Switch statement.")
        }
        
        for item in cases {
            if let value = try item.textExpression?.evaluate() {
                if value.string == testValue.string {
                    shouldAbort = false
                    returnResult = nil
                    for instruction in item.instructions {
                        try instruction.execute()
                        if shouldAbort {
                            break
                        }
                    }
                    
                    return nil
                }
            } else {
                throw GraceRuntimeError.formulaError(message: "Unable to evaluate an expression for a Case statement.")
            }
        }
        
        // Execute the default if it exists
        if let defaultCase {
            shouldAbort = false
            returnResult = nil
            for instruction in defaultCase.instructions {
                try instruction.execute()
                if shouldAbort {
                    break
                }
            }
        }
        
        return returnResult
    }
    
    
}

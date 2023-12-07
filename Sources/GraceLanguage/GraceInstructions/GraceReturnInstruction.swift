//
//  GraceReturnInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/29/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Returns a `GraceVariable` containing a result to a function caller. Execution of any `GraceInstructions` will stop and control will be returned to the caller instantly.
///
/// For Example:
/// ```
/// import StandardLib;
/// import StringLib;
///
/// main {
/// var saying:string = @sayHello("World");
///
/// call @print($saying);
/// }
///
/// function sayHello(name:string) returns string {
/// return @format("Hello {0}!", [$name]);
/// }
/// ```
open class GraceReturnInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` that this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The value to return to the caller.
    public var expression:GraceExpression? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` that this instruction belongs to.
    ///   - expression: The value to return to the caller.
    public init(parent: GraceInstruction? = nil, expression: GraceExpression? = nil) {
        self.parent = parent
        self.expression = expression
    }
    
    // MARK: - Functions
    /// Executes the instruction and returns the given value to the caller.
    /// - Returns: Returns the given value to the caller.
    public func execute() throws -> GraceVariable? {
        var value:GraceVariable? = nil
        
        // Are we returning a value?
        if let expression {
            value = try expression.evaluate()
            if value == nil {
                throw GraceRuntimeError.formulaError(message: "Unable to evaluate an expression for a Return statement.")
            }
        }
        
        if let parent {
            bubbleUpAbort(for: parent, value: value)
        }
        
        return value
    }
    
    /// Bubbles an abort execution up through the calling stack for the function.
    /// - Parameters:
    ///   - instruction: The parent `GraceInstruction`.
    ///   - value: The return result as a `GraceVariable`.
    private func bubbleUpAbort(for instruction:GraceInstruction, value:GraceVariable?) {
        var bubbleToTop:Bool = true
        
        if instruction is GraceFunction {
            bubbleToTop = false
        }
        
        if var abortable = instruction as? GraceAbortable {
            abortable.shouldAbort = true
            abortable.returnResult = value
            
            if let parent = instruction.parent {
                if bubbleToTop {
                    bubbleUpAbort(for: parent, value: value)
                }
            }
        } else if let parent = instruction.parent {
            bubbleUpAbort(for: parent, value: value)
        }
    }
}

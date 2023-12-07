//
//  GraceForInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/28/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Loops through a given range of numbers. Specify the name of a new `GraceVariable` to hold the current value along with the starting and ending values.
///
/// For Example:
/// ```
/// import StandardLib;
///
/// main {
/// var colors:string array = ["red", "yellow", "green"];
/// var max:int = (@count($colors) - 1);
///
/// for n in 0 to max {
/// var color:string = $colors[n];
/// call @printf("Color at {0} is {1}", [$n, $color]);
/// }
///
/// }
/// ```
open class GraceForInstruction:GraceInstruction, GraceAbortable {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` for this instruction.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of a new `GraceVariable` that will hold the current index.
    public var iteratorName:String = ""
    
    /// The starting value for the for-loop.
    public var fromExpression:GraceExpression? = nil
    
    /// The ending value for the for-loop.
    public var toExpression:GraceExpression? = nil
    
    /// The list of `GraceInstructions` to run on each iteration.
    public var instructions:[GraceInstruction] = []
    
    /// If `true`, stop executing `GraceInstructions` and return to the caller.
    public var shouldAbort:Bool = false
    
    /// A `GraceVariable` holding the results to return to the caller.
    public var returnResult: GraceVariable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` for this instruction.
    ///   - iteratorName: The name of a new `GraceVariable` that will hold the current index.
    ///   - fromExpression: The starting value for the for-loop.
    ///   - toExpression: The ending value for the for-loop.
    public init(parent: GraceInstruction? = nil, iteratorName: String, fromExpression: GraceExpression? = nil, toExpression: GraceExpression? = nil) {
        self.parent = parent
        self.iteratorName = iteratorName
        self.fromExpression = fromExpression
        self.toExpression = toExpression
    }
    
    // MARK: - Functions
    /// Executes the instruction and loops over the given number range executing the given `GraceInstructions`.
    /// - Returns: Returns the iterator `GraceVariable`.
    public func execute() throws -> GraceVariable? {
        let iterator:GraceVariable = GraceVariable(name: iteratorName, value: "0", type: .int)
        
        guard let fromValue = try fromExpression?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Unable to evaluate the For Loop From expression.")
        }
        
        guard let toValue = try toExpression?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Unable to evaluate the For Loop To expression.")
        }
        
        let a = fromValue.int
        let b = toValue.int
        variables[iteratorName] = iterator
        
        shouldAbort = false
        returnResult = nil
        for n in a...b {
            iterator.int = n
            
            for instruction in instructions {
                try instruction.execute()
                if shouldAbort {
                    return iterator
                }
            }
        }
        
        variables = [:]
        
        return iterator
    }
    
}

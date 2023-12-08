//
//  GraceFormulaExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// A `GraceFormulaExpression` returns the result of a calculation or a boolean evaluation. All Grace calculations must be in the form `(leftOperand operation rightOperand)`, for example `(1 + 2)` or `(1 < 2)`.
///
/// In a Grace App:
/// ```
/// import StandardLib;
/// 
/// main {
/// var n:int = ((1 + 2) + 2);
///
/// if ($n >= 5) {
/// call @print("Greater than 5")
/// }
///
/// }
open class GraceFormulaExpression:GraceExpression {
    
    // MARK: - Properties
    /// The left side of the operation.
    public var leftOperand:GraceExpression? = nil
    
    /// The math operation to perform or the boolean comparision to make.
    public var operation:String = ""
    
    /// The right side of the operation.
    public var rightOperand:GraceExpression? = nil
    
    // MARK: - Initializer
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - leftOperand: The left side of the operation.
    ///   - operation: The math operation to perform or the boolean comparision to make.
    ///   - rightOperand: The right side of the operation.
    public init(leftOperand: GraceExpression? = nil, operation: String, rightOperand: GraceExpression? = nil) {
        self.leftOperand = leftOperand
        self.operation = operation
        self.rightOperand = rightOperand
    }
    
    // MARK: - Functions
    public func evaluate() throws -> GraceVariable? {
        
        guard let leftValue = try leftOperand?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Missing or invalid left operator.")
        }
        
        guard let rightValue = try rightOperand?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Missing or invalid right operator.")
        }
        
        // Take action based on the left side type
        switch leftValue.type {
        case .string:
            switch operation {
            case "+":
                return GraceVariable(name: "result", value: leftValue.string + rightValue.string)
            case "=":
                return GraceVariable(name: "result", value: (leftValue.string == rightValue.string))
            case "!=":
                return GraceVariable(name: "result", value: (leftValue.string != rightValue.string))
            default:
                throw GraceRuntimeError.formulaError(message: "Invalid fomula operation '\(operation)' for left side type '\(leftValue.type)'.")
            }
        case .enumeration:
            switch operation {
            case "=":
                return GraceVariable(name: "result", value: (leftValue.string == rightValue.string))
            case "!=":
                return GraceVariable(name: "result", value: (leftValue.string != rightValue.string))
            default:
                throw GraceRuntimeError.formulaError(message: "Invalid fomula operation '\(operation)' for left side type '\(leftValue.type)'.")
            }
        case .bool:
            switch operation {
            case "=":
                return GraceVariable(name: "result", value: (leftValue.bool == rightValue.bool))
            case "&":
                return GraceVariable(name: "result", value: (leftValue.bool && rightValue.bool))
            case "|":
                return GraceVariable(name: "result", value: (leftValue.bool || rightValue.bool))
            case "!=":
                return GraceVariable(name: "result", value: (leftValue.bool != rightValue.bool))
            default:
                throw GraceRuntimeError.formulaError(message: "Invalid fomula operation '\(operation)' for left side type '\(leftValue.type)'.")
            }
        case .int:
            switch operation {
            case "+":
                return GraceVariable(name: "result", value: leftValue.int + rightValue.int)
            case "-":
                return GraceVariable(name: "result", value: leftValue.int - rightValue.int)
            case "*":
                return GraceVariable(name: "result", value: leftValue.int * rightValue.int)
            case "/":
                return GraceVariable(name: "result", value: leftValue.int / rightValue.int)
            case "=":
                return GraceVariable(name: "result", value: (leftValue.int == rightValue.int))
            case "!=":
                return GraceVariable(name: "result", value: (leftValue.int != rightValue.int))
            case "<":
                return GraceVariable(name: "result", value: (leftValue.int < rightValue.int))
            case ">":
                return GraceVariable(name: "result", value: (leftValue.int > rightValue.int))
            case "<=":
                return GraceVariable(name: "result", value: (leftValue.int <= rightValue.int))
            case ">=":
                return GraceVariable(name: "result", value: (leftValue.int >= rightValue.int))
            default:
                throw GraceRuntimeError.formulaError(message: "Invalid fomula operation '\(operation)' for left side type '\(leftValue.type)'.")
            }
        case .float:
            switch operation {
            case "+":
                return GraceVariable(name: "result", value: leftValue.float + rightValue.float)
            case "-":
                return GraceVariable(name: "result", value: leftValue.float - rightValue.float)
            case "*":
                return GraceVariable(name: "result", value: leftValue.float * rightValue.float)
            case "/":
                return GraceVariable(name: "result", value: leftValue.float / rightValue.float)
            case "=":
                return GraceVariable(name: "result", value: (leftValue.float == rightValue.float))
            case "!=":
                return GraceVariable(name: "result", value: (leftValue.float != rightValue.float))
            case "<":
                return GraceVariable(name: "result", value: (leftValue.float < rightValue.float))
            case ">":
                return GraceVariable(name: "result", value: (leftValue.float > rightValue.float))
            case "<=":
                return GraceVariable(name: "result", value: (leftValue.float <= rightValue.float))
            case ">=":
                return GraceVariable(name: "result", value: (leftValue.float >= rightValue.float))
            default:
                throw GraceRuntimeError.formulaError(message: "Invalid fomula operation '\(operation)' for left side type '\(leftValue.type)'.")
            }
        default:
            throw GraceRuntimeError.formulaError(message: "Invalid fomula left side type '\(leftValue.type)'.")
        }
    }
}

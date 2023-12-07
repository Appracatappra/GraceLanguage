//
//  GraceNotExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Performs a boolean negation on the given boolean value or expression.
///
/// For example:
/// ```
/// import StandardLib;
/// 
/// main {
/// var found:bool = false;
///
/// if not $found {
/// call @print("Not found");
/// }
///
/// }
/// ```
open class GraceNotExpression:GraceExpression {
    
    // MARK: - Properties
    public var operand:GraceExpression? = nil
    
    // MARK: - Initializers
    public init() {
        
    }
    
    public init(operand: GraceExpression? = nil) {
        self.operand = operand
    }
    
    // MARK: - Functions
    public func evaluate() throws -> GraceVariable? {
        
        guard let value = try operand?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Missing operand for NOT expression.")
        }
        
        switch value.type {
        case .bool:
            return GraceVariable(name: "result", value: !value.bool)
        default:
            throw GraceRuntimeError.formulaError(message: "Invalid operand type '\(value.type)' for NOT expression.")
        }
    }
}

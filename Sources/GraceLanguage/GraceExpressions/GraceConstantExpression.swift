//
//  GraceConstantExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Holds a literal constant used in places like variable initialization and function calls.
///
/// For example, assigning `0` to variable `n` when it is created:
/// ```
/// main {
/// var n:int = 0;
/// }
/// ```
open class GraceConstantExpression:GraceExpression {
    
    // MARK: - Properties
    /// Holds the constant value.
    public var value:String = ""
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameter value: The constant value,
    public init(value: String) {
        self.value = value
    }
    
    // MARK: - Functions
    /// Evaluates the expression.
    /// - Returns: Returns the constant value.
    public func evaluate() throws -> GraceVariable? {
        return GraceVariable(name: "constant", value: value)
    }
}

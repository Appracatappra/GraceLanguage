//
//  GraceArrayExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Creates a new `GraceArray` with the given contents. An array constant must be a coma separated list of items and start with a `[` and end with a `]`.
///
/// For example:
/// ```
/// main {
/// var colors:string array = ["red", "yellow", "green"];
/// }
/// ```
open class GraceArrayExpression:GraceExpression {
    
    // MARK: - Properties
    /// The list of elements for the array.
    public var elements:[GraceExpression] = []
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameter elements: The list of elements for the array.
    public init(elements: [GraceExpression]) {
        self.elements = elements
    }
    
    // MARK: - Functions
    /// Evaluates the expression and returns an array of items.
    /// - Returns: Returns a `GraceArray` containing the list of specified elements.
    public func evaluate() throws -> GraceVariable? {
        let array:GraceVariable = GraceVariable()
        
        array.rawValue = []
        for element in elements {
            if let value = try element.evaluate() {
                array.type = value.type
                array.append(value.string)
            }
        }
        
        return array
    }
}

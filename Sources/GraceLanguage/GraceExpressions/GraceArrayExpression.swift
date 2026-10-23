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
    
    /// Provides access to the executable where this object if defined.
    public weak var coreExe:GraceExecutable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameter elements: The list of elements for the array.
    /// - Parameter exe: The parent exe.
    public init(exe:GraceExecutable, elements: [GraceExpression]) {
        self.elements = elements
        self.coreExe = exe
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
        
        GraceRuntime.shared.logTracerEvent(type: .arrayExe, message: "Evaluating `\(String(describing: coreExe?.namespace)):Array` = \(array.rawValue).")
        
        return array
    }
}

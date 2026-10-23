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
    
    /// Provides access to the executable where this object if defined.
    public weak var coreExe:GraceExecutable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameter value: The constant value,
    /// - Parameter exe: The parent exe.
    public init(exe:GraceExecutable, value: String) {
        self.value = value
        self.coreExe = exe
    }
    
    // MARK: - Functions
    /// Evaluates the expression.
    /// - Returns: Returns the constant value.
    public func evaluate() throws -> GraceVariable? {
        
        GraceRuntime.shared.logTracerEvent(type: .constantExe, message: "Setting `\(String(describing: coreExe?.namespace)):Constant` = `\(value)`")
        
        return GraceVariable(name: "constant", value: value)
    }
}

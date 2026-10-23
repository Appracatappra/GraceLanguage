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
    
    /// Provides access to the executable where this object if defined.
    public weak var coreExe:GraceExecutable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - exe: The parent exe.
    ///   - operand: The operand.
    public init(exe:GraceExecutable, operand: GraceExpression? = nil) {
        self.operand = operand
        self.coreExe = exe
    }
    
    // MARK: - Functions
    public func evaluate() throws -> GraceVariable? {
        
        guard let value = try operand?.evaluate() else {
            throw GraceRuntimeError.formulaError(message: "Missing operand for NOT expression.")
        }
        
        GraceRuntime.shared.logTracerEvent(type: .notExe, message: "Negating a boolean.")
        
        switch value.type {
        case .bool:
            return GraceVariable(name: "result", value: !value.bool)
        default:
            throw GraceRuntimeError.formulaError(message: "Invalid operand type '\(value.type)' for NOT expression.")
        }
    }
}

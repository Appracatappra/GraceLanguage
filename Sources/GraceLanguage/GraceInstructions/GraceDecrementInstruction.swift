//
//  GraceDecrementInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/30/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Decrements a `GraceVariable` of type `int` or `float` by `1`.
///
/// For Example:
/// ```
/// main {
/// var n:int = 1;
/// decrement $n;
/// }
/// ```
open class GraceDecrementInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceVariable` to decrement.
    public var variableName:String = ""
    
    /// Provides access to the executable where this object if defined.
    public weak var coreExe:GraceExecutable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - variableName: The name of the `GraceVariable` to decrement.
    ///   - exe: The parent exe.
    public init(exe:GraceExecutable, parent: GraceInstruction? = nil, variableName: String) {
        self.parent = parent
        self.variableName = variableName
        self.coreExe = exe
    }
    
    // MARK: - Functions
    /// Executes the instruction and decrements the given variable.
    /// - Returns: Returns `nil`.
    public func execute() throws -> GraceVariable? {
        
        guard let parent else {
            throw GraceRuntimeError.unknownVariable(message: "Unknown variable `\(variableName)`.")
        }
        
        guard let variable = GraceRuntime.getVariable(name: variableName, from: parent) else {
            throw GraceRuntimeError.unknownVariable(message: "Unknown variable `\(variableName)`.")
        }
        
        variable.int = variable.int - 1
        
        GraceRuntime.shared.logTracerEvent(type: .variableExe, message: "Decrementing `\(String(describing: coreExe?.namespace)):\(variableName)` = \(variable.rawValue).")
        
        return nil
    }
}

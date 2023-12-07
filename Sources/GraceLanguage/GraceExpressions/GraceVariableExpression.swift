//
//  GraceVariableExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Returns the contents of a `GraceVariable`. When dereferencing a `GraceVariable`, the variable name must always start with a `$`.
///
/// For example, to access variable `n`, we use `$n`:
/// ```
/// import StandardLib;
/// 
/// main {
/// var n:int = 0;
/// call @print($n);
/// }
/// ```
open class GraceVariableExpression:GraceExpression {
    
    // MARK: - Properties
    /// The `GraceInstruction` that this variable dereference belongs to.
    public var parent:GraceInstruction? = nil
    
    /// The name the of `GraceVariable` to return.
    public var variableName:String = ""
    
    /// The options name of a sub property such as an element from a `GraceEnumeration` or a property of a `GraceStructure`.
    public var propertyName:String = ""
    
    /// For an array, this will contain the index of the element in the array to dereference.
    public var indexExpression:GraceExpression? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The `GraceInstruction` that this variable dereference belongs to.
    ///   - variableName: The name the of `GraceVariable` to return.
    ///   - propertyName: The options name of a sub property such as an element from a `GraceEnumeration` or a property of a `GraceStructure`.
    ///   - index: For an array, this will contain the index of the element in the array to dereference.
    public init(parent: GraceInstruction? = nil, variableName: String, propertyName: String = "", index: GraceExpression? = nil) {
        self.parent = parent
        self.variableName = variableName
        self.propertyName = propertyName
        self.indexExpression = index
    }
    
    // MARK: - Functions
    /// Evaulates the expression and returns the value of a `GraceVariable`.
    /// - Returns: Returns the requested value if found, else returns `nil`.
    public func evaluate() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        var index:Int = -1
        
        if let parent {
            variable = GraceRuntime.getVariable(name: variableName, from: parent)
        }
        
        if let indexExpression {
            if let value = try indexExpression.evaluate() {
                index = value.int
            }
        }
        
        if let variable {
            if propertyName != "" {
                if variable.type == .structure {
                    let structure = GraceContainer.unbox(value: variable.string)
                    if let value = structure[propertyName] {
                        return value
                    } else {
                        throw GraceRuntimeError.unknownProperty(message: "Variable `\(variable.name)` does not contain property `\(propertyName)`.")
                    }
                } else {
                    throw GraceRuntimeError.unknownProperty(message: "Variable `\(variable.name)` does not contain property `\(propertyName)`.")
                }
            } else if index > -1 {
                if index < variable.count {
                    return GraceVariable(name: variableName, value: variable.string(index))
                } else {
                    throw GraceRuntimeError.indexOutOfBounds(message: "Index `\(index)` is out of bounds in variable `\(variable.name)`.")
                }
            }
        } else {
            throw GraceRuntimeError.unknownVariable(message: "Variable `\(variableName)` not found.")
        }
        
        return variable
    }
    
}

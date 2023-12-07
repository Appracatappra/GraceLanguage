//
//  GraceLetInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/27/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Sets the value of a `GraceVariable` to the given constant, variable, formula and function value. When dereferenceing a `GraceVariable` the name must start with a `$`. enumberation names start with `#` and enimeration or structure properties start with `~`.
/// 
/// For example:
/// ```
/// enumeration Colors {
/// red,
/// yellow,
/// green
/// }
///
/// struct FullName {
/// firstName:string,
/// lastName:string
/// }
///
/// main {
/// var n:int;
/// var list:string array = ["one", "two"];
/// var color:enumeration Colors = #Colors~red;
/// var name:structure FullName = new FullName(firstName:"John", lastName:"Doe");
///
/// let $n = (1 + 1);
/// let $color = #Colors~green;
/// let $list[1] = "2";
/// let $name~firstName = "Jane";
/// }
/// ```
///
open class GraceLetInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The `GraceExecutable` that contains the `GraceFunction` definition.
    public var executable:GraceExecutable? = nil
    
    /// The parent `GraceInstruction` this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// A list of `GraceVariables` belonging to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceVariable` to set.
    public var variableName:String = ""
    
    /// The options name of a sub property such as an element from a `GraceEnumeration` or a property of a `GraceStructure`.
    public var propertyName:String = ""
    
    /// For an array, this will contain the index of the element in the array to dereference.
    public var indexExpression:GraceExpression? = nil
    
    /// The value to set he `GraceVariable` to.
    public var expression:GraceExpression? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` this instruction belongs to.
    ///   - variableName: The name of the `GraceVariable` to set.
    ///   - propertyName: The options name of a sub property such as an element from a `GraceEnumeration` or a property of a `GraceStructure`.
    ///   - indexExpression: For an array, this will contain the index of the element in the array to dereference.
    ///   - expression: The value to set he `GraceVariable` to.
    public init(parent: GraceInstruction? = nil, variableName: String, propertyName: String, indexExpression: GraceExpression? = nil, expression: GraceExpression? = nil) {
        self.parent = parent
        self.variableName = variableName
        self.propertyName = propertyName
        self.indexExpression = indexExpression
        self.expression = expression
    }
    
    // MARK: - Functions
    /// Executes the instruction and sets the value of the given `GraceVariable`.
    /// - Returns: Returns the `GraceVariable` being adjusted.
    public func execute() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        var index:Int = -1
        
        guard let value = try expression?.evaluate() else {
            throw GraceRuntimeError.variableError(message: "Unable to evaluate expression to change variable `\(variableName)`.")
        }
        
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
                    var structure = GraceContainer.unbox(value: variable.string)
                    if structure.keys.contains(propertyName) {
                        structure[propertyName] = value
                        variable.string = GraceContainer.box(structure: structure)
                    } else {
                        throw GraceRuntimeError.unknownProperty(message: "Variable `\(variable.name)` does not contain property `\(propertyName)`.")
                    }
                } else {
                    throw GraceRuntimeError.unknownProperty(message: "Variable `\(variable.name)` does not contain property `\(propertyName)`.")
                }
            } else if index > -1 {
                if index < variable.count {
                    variable.rawValue[index] = value.string
                } else {
                    throw GraceRuntimeError.indexOutOfBounds(message: "Index `\(index)` is out of bounds in variable `\(variable.name)`.")
                }
            } else {
                variable.string = value.string
            }
            
            // Is the variable holding an enumeration?
            if variable.type == .enumeration {
                let enumeration = try GraceRuntime.getEnumeration(name: variable.subtypeName, from: executable)
                
                // Is the variable's value a valid enumeration value?
                if !enumeration.hasProperty(value.string) {
                    throw GraceRuntimeError.unknownProperty(message: "Invalid property `\(variable.string)` for enumeration `\(enumeration.name)` when setting variable `\(variable.name)`.")
                }
            }
        } else {
            throw GraceRuntimeError.unknownVariable(message: "Variable `\(variableName)` not found.")
        }
        
        return variable
    }
}

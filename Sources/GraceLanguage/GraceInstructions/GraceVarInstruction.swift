//
//  GraceVarInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Creates a new instance of a `GraceVariable` as either a simple type (like `string` or `int`) or creates an instance of a `GraceEnumeration` or `GraceStructure`. To create a `GraceArray`, add the keyword `array` after the variable type definition, for example `string array`. When creating a new variable, you can optionally specify an initinal value. Additionally, variables are scoped to the container they are defined in, so variable defined outside of `main` or `function` are global.
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
/// var text:string = "Hello World!";
///
/// main {
/// var n:int;
/// var list:string array = ["one", "two"];
/// var color:enumeration Colors = #Colors~red;
/// var name:structure FullName = new FullName(firstName:"John", lastName:"Doe");
/// }
/// ```
///
/// The following types are supported:
/// * `string` - A string of characters. The string can be single or double quoted.
/// * `bool` - A `true` or `false` value.
/// * `int` - A whole integer value.
/// * `float` - A float value with a decimal and a fraction.
/// * `any` - A variable that can contain any value.
/// * `null` - A variable is nothing.
/// * `enumeration` - The variable contains a `GraceEnumeration`. The name of the enumeration is specified after `enumeration` keyword.
/// * `structure` - The variable contains a `GraceStructure`. The name of the enumeration is specified after `structure` keyword.
open class GraceVarInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The parent `GraceInstruction` the the new variable will be created in.
    public var parent:GraceInstruction? = nil
    
    /// A list of `GraceVariables` belonging to this instruction.
    public var variables:GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceVariable` to create.
    public var name:String = ""
    
    /// The type of `GraceVariable` to create.
    public var type:GraceVariable.VariableType = .null
    
    /// For enumerations or structures, the name of the given `GraceEnumeration` or `GraceStructure`.
    public var subtypeName:String = ""
    
    /// If `true`, the variable created will be an array.
    public var isArray:Bool = false
    
    /// The default value for the `GraceVariable`.
    public var defaultValue:GraceExpression? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - parent: The parent `GraceInstruction` the the new variable will be created in.
    ///   - name: The name of the `GraceVariable` to create.
    ///   - type: The type of `GraceVariable` to create.
    ///   - subtypeName: For enumerations or structures, the name of the given `GraceEnumeration` or `GraceStructure`.
    ///   - isArray: If `true`, the variable created will be an array.
    ///   - defaultValue: The default value for the `GraceVariable`.
    public init(parent: GraceInstruction? = nil, name: String, type: GraceVariable.VariableType, subtypeName: String = "", isArray: Bool = false, defaultValue: GraceExpression? = nil) {
        self.parent = parent
        self.name = name
        self.type = type
        self.subtypeName = subtypeName
        self.isArray = isArray
        self.defaultValue = defaultValue
    }
    
    // MARK: - Functions
    /// Executes the instruction to create the requested `GraceVariable`.
    /// - Returns: Returns the `GraceVariable` created.
    public func execute() throws -> GraceVariable? {
        var variable:GraceVariable? = nil
        
        guard var parent else {
            throw GraceRuntimeError.variableError(message: "Unable to create variable `\(name)`.")
        }
        
        if let defaultValue {
            if let value = try defaultValue.evaluate() {
                variable = value
                variable?.name = name
                variable?.type = type
            } else {
                throw GraceRuntimeError.formulaError(message: "Unable to set default value for variable `\(name)`.")
            }
        } else {
            variable = GraceVariable(name: name, value: "", type: type)
        }
        
        // Set subtype
        variable?.subtypeName = subtypeName
        
        // Store variable in parent
        parent.variables[name] = variable
        
        return variable
    }
    
    
}

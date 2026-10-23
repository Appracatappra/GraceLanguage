//
//  GraceCallInstruction.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/29/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Calls a previously defined `GraceFunction`. When calling a `GraceFunction` the name of the function must start with a `@`. Any optional parameters are passed to the function as unnamed values.
///
/// For Example:
/// ```
/// import StandardLib;
///
/// main {
/// call @sayHello("World");
/// }
///
/// function sayHello(name:string) {
/// call @printf("Hello {0}!", [$name]);
/// }
/// ```
open class GraceCallInstruction:GraceInstruction {
    
    // MARK: - Properties
    /// The `GraceExecutable` that contains the `GraceFunction` definition.
    public var executable:GraceExecutable? = nil
    
    /// The parent `GraceInstruction` that this instruction belongs to.
    public var parent: GraceInstruction? = nil
    
    /// The `GraceVariables` that belong to this instruction.
    public var variables: GraceContainer.GraceStructure = [:]
    
    /// The name of the `GraceFunction` to call.
    public var functionName:String = ""
    
    /// A list of values to pass to the function.
    public var parameters:[GraceExpression] = []
    
    /// Provides access to the executable where this object if defined.
    public weak var coreExe:GraceExecutable? = nil
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - executable: The `GraceExecutable` that contains the `GraceFunction` definition.
    ///   - parent: The parent `GraceInstruction` that this instruction belongs to.
    ///   - functionName: The name of the `GraceFunction` to call.
    ///   - parameters: A list of values to pass to the function.
    public init(exe:GraceExecutable, executable: GraceExecutable? = nil, parent: GraceInstruction? = nil, functionName: String, parameters: [GraceExpression] = []) {
        self.executable = executable
        self.parent = parent
        self.functionName = functionName
        self.parameters = parameters
        self.coreExe = exe
    }
    
    // MARK: - Functions
    /// Executes the instruction and calls the given `GraceFunction` with the given list of parameter values.
    /// - Returns: Returns the variable result.
    public func execute() throws -> GraceVariable? {
        let function = try GraceRuntime.getFunction(name: functionName, from: executable)
        
        GraceRuntime.shared.logTracerEvent(type: .callExe, message: "Calling function `\(String(describing: coreExe?.namespace)):\(functionName)`.")
        
        // Assign parameters to function
        for n in 0..<function.parameterNames.count {
            let name = function.parameterNames[n]
            let type = function.parameterTypes[n]
            if parameters.count > 0 && n < parameters.count {
                if let value = try parameters[n].evaluate() {
                    value.type = type
                    function.variables[name] = value
                } else {
                    function.variables[name] = GraceVariable(name: name, value: "", type: .null)
                }
            } else {
                throw GraceRuntimeError.missingParameter(message: "Parameter `\(name)` not provided in function call `\(functionName)`.")
            }
        }
        
        // Copy and restore variable space for recursion
        let variables = function.variables
        let result = try function.execute()
        function.variables = variables
        
        return result
    }
    
}

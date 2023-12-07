//
//  GraceFunctionExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Calls a `GraceFunction` in places such as variable initialization or other function calls. When dereferenceing a `GraceFunction` the name of the function must start with a `@`.
///
/// For example:
/// ```
/// main {
/// var text:string = @sayHello();
/// }
///
/// function sayHello() returns string {
/// return "Hello World";
/// }
/// ```
open class GraceFunctionExpression:GraceExpression {
    
    // MARK: - Properties
    /// The `GraceExecutable` that this expression belongs to.
    public var executable:GraceExecutable? = nil
    
    /// The name of the `GraceFunction` being called.
    public var functionName:String = ""
    
    /// The list of values being passed to the `GraceFunction`.
    public var parameters:[GraceExpression] = []
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - executable: The `GraceExecutable` that this expression belongs to.
    ///   - functionName: The name of the `GraceFunction` being called.
    ///   - parameters: The list of values being passed to the `GraceFunction`.
    public init(executable: GraceExecutable? = nil, functionName: String, parameters: [GraceExpression] = []) {
        self.executable = executable
        self.functionName = functionName
        self.parameters = parameters
    }
    
    // MARK: - Functions
    /// Evaluates the expression and returns the result of the function.
    /// - Returns: Returns the result of executing the `GraceFunction`.
    public func evaluate() throws -> GraceVariable? {
        let function = try GraceRuntime.getFunction(name: functionName, from: executable)
        
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

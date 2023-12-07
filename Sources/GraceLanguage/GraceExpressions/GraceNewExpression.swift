//
//  GraceNewExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Creates a new instance of a `GraceStructure`. Default values for the structures properties can be provided during instantiation.
///
/// For example:
/// ```
/// structure FullName {
/// firstName:string,
/// lastName:string
/// }
///
/// main {
/// var name:structure FullName = new FullName(firstName:"John", lastName:"Doe");
/// var otherName:structure FullName = new FullName();
/// }
/// ```
/// - Remark: A `GraceStructure` can only contain simply types such as `string` or `int`, sub-structures are currently not supported.
open class GraceNewExpression:GraceExpression {
    
    // MARK: - Properties
    /// The `GraceExecutable` this expression belongs to.
    public var executable:GraceExecutable? = nil
    
    /// The name of the `GraceStructure` to instantiate.
    public var structureName:String = ""
    
    /// The list of property names being set.
    public var parameterNames:[String] = []
    
    /// The list of property values being set.
    public var parameterValues:[GraceExpression] = []
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - executable: The `GraceExecutable` this expression belongs to.
    ///   - structureName: The name of the `GraceStructure` to instantiate.
    ///   - parameterNames: The list of property names being set.
    ///   - parameterValues: The list of property values being set.
    public init(executable: GraceExecutable? = nil, structureName: String, parameterNames: [String] = [], parameterValues: [GraceExpression] = []) {
        self.executable = executable
        self.structureName = structureName
        self.parameterNames = parameterNames
        self.parameterValues = parameterValues
    }
    
    // MARK: - Functions
    /// Evaluates the expression and returns a new instance of a `GraceStructure`.
    /// - Returns: Returns the newly created `GraceStructure`.
    public func evaluate() throws -> GraceVariable? {
        let prototype = try GraceRuntime.getContainer(name: structureName, from: executable)
        var structure = prototype.new()
        
        // Set values from passed parameters
        for n in 0..<parameterNames.count {
            let name = parameterNames[n]
            if let value = try parameterValues[n].evaluate() {
                structure[name] = value
            }
        }
        
        return GraceVariable(name: structureName, value: GraceContainer.box(structure: structure), type: .structure)
    }
    
}

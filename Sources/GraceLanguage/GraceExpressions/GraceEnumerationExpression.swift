//
//  GraceEnumerationExpression.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/30/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Returns a property from a `GraceEnumeration` in areas such as variable initialization or in function calls. When dereferencing a `GraceEnumeration` the name of the enumeration must start with a `#` and the propert name must start with a `~`.
///
/// For example:
/// ```
/// enumeration Colors {
/// red,
/// yellow,
/// green
/// }
///
/// main {
/// var color:enumeration Colors = #Colors~green;
/// }
open class GraceEnumerationExpression:GraceExpression {
    
    // MARK: - Properties
    /// The `GraceExecutable`  that this enumeration belongs to.
    public var executable:GraceExecutable? = nil
    
    /// The name of the `GraceEnumeration` to dereference.
    public var enumerationName:String = ""
    
    /// The name of the `GraceEnumeration` property that is being returned.
    public var propertyName:String = ""
    
    // MARK: - Initializers
    /// Creates an instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - executable: The `GraceExecutable`  that this enumeration belongs to.
    ///   - enumerationName: The name of the `GraceEnumeration` to dereference.
    ///   - propertyName: The name of the `GraceEnumeration` property that is being returned.
    public init(executable:GraceExecutable? = nil, enumerationName: String, propertyName: String) {
        self.executable = executable
        self.enumerationName = enumerationName
        self.propertyName = propertyName
    }
    
    // MARK: - Functions
    /// Evaluates the expression and returns the given property of the given `GraceEnumeration`.
    /// - Returns: The value of the requested `GraceEnumeration` propert.
    public func evaluate() throws -> GraceVariable? {
        
        guard let executable else {
            throw GraceRuntimeError.unknownEnumeration(message: "Unknown enumeration `\(enumerationName)`.")
        }
        
        let enumeration = try GraceRuntime.getEnumeration(name: enumerationName, from: executable)
        
        if enumeration.hasProperty(propertyName) {
            return GraceVariable(name: "result", value: propertyName, type: .enumeration)
        } else {
            throw GraceRuntimeError.unknownProperty(message: "Enumeration `\(enumerationName)` does not contain property `\(propertyName)`.")
        }
    }
}

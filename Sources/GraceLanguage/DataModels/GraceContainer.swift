//
//  GraceStructure.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/25/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Contains the definition of a `GraceStructure` prototype along with the routines to move the structure in and out of storage.
open class GraceContainer {
    /// Defines a `GraceStructure`.
    public typealias GraceStructure = [String:GraceVariable]
    
    // MARK: - Static Functions
    /// Compresses a `GraceStructure` instance for storage in a `GraceVariable`.
    /// - Parameter structure: The structure to compress.
    /// - Returns: The compressed version of the `GraceStructure`.
    public static func box(structure:GraceStructure) -> String {
        let serializer = Serializer(divider: "∆")
        
        for (key, value) in structure {
            let element = "\(key)ƒ\(value.string)"
            serializer.append(element)
        }
        
        return serializer.value
    }
    
    /// Decompresses a `GraceStructure` from a `GraceVariable`.
    /// - Parameter value: A compressed representation of a `GraceStructure`.
    /// - Returns: Returns the decompressed `GraceStructure`.
    public static func unbox(value:String) -> GraceStructure {
        var structure:GraceStructure = [:]
        let deserializer = Deserializer(text: value, divider: "∆")
        
        for _ in 0..<deserializer.items {
            let elementDeserializer = Deserializer(text: deserializer.string(), divider: "ƒ")
            let key = elementDeserializer.string()
            let value = elementDeserializer.string()
            
            structure[key] = GraceVariable(name: key, value: value)
        }
        
        return structure
    }
    
    // MARK: - Properties
    /// The name of the structure.
    public var name:String = ""
    
    /// A list of property names.
    public var propertyNames:[String] = []
    
    /// A list of property types.
    public var PropertyTypes:[GraceVariable.VariableType] = []
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates an instance.
    /// - Parameters:
    ///   - name: The name of the structure.
    ///   - propertyNames: A list of property names.
    ///   - types: A list of property types.
    public init(name: String, propertyNames: [String] = [], types: [GraceVariable.VariableType] = []) {
        self.name = name
        self.propertyNames = propertyNames
        self.PropertyTypes = types
    }
    
    // MARK: - Functions
    /// Creates a new `GraceStructure` for the prototype.
    /// - Returns: Returns the new `GraceStructure`.
    public func new() -> GraceStructure {
        var structure:GraceStructure = [:]
        
        for i in 0..<propertyNames.count {
            let element = propertyNames[i]
            let type = PropertyTypes[i]
            
            structure[element] = GraceVariable(name: element, value: "", type: type)
        }
        
        return structure
    }
}

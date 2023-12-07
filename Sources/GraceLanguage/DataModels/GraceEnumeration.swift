//
//  GraceEnumeration.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/30/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Holds a `GraceEnumeration` definition.
open class GraceEnumeration {
    
    // MARK: - Properties
    /// The name of the enumeration.
    public var name:String = ""
    
    /// The list of enumeration properties.
    public var properties:[String] = []
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameter name: The name of the enumeration.
    public init(name: String) {
        self.name = name
    }
    
    // MARK: - Functions
    ///  Check to see if the enumeration has the given property.
    /// - Parameter name: The property to check for.
    /// - Returns: Returns `true` if the enumeration contains the property, else returns `false`.
    public func hasProperty(_ name:String) -> Bool {
        for property in properties {
            if property == name {
                return true
            }
        }
        
        return false
    }
}

//
//  File.swift
//  GraceLanguage
//
//  Created by Kevin Mullins on 10/7/26.
//

import Foundation
import SwiftletUtilities

public extension Dictionary {
    
    /// Gets a property from a Grace Structure.
    /// - Parameter name: The name of the property to return.
    /// - Returns: Returns the property as a `GraceVariable` or an empty `GraceVariable` if not found.
    func property(_ name:String) -> GraceVariable {
        // Define empty property.
        let empty = GraceVariable(name: "Empty", value: "")
        
        // Has value?
        if let key = name as? Key {
            // Yes, has variable property?
            if let variable = self[key] {
                // Yes, is Grace Variable?
                if let result = variable as? GraceVariable {
                    // Yes, return property.
                    return result
                }
            }
        }
        
        // Default to empty property.
        return empty
    }
    
    /// Adds or sets the Grace Structure property to the given value.
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - value: The value of the property.
    mutating func setProperty(_ name:String, value:Bool) {
        let variable = GraceVariable(name: name, value: value)
        
        if let key = name as? Key {
            if let property = variable as? Value {
                self[key] = property
            }
        }
    }
    
    /// Adds or sets the Grace Structure property to the given value.
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - value: The value of the property.
    mutating func setProperty(_ name:String, value:Int) {
        let variable = GraceVariable(name: name, value: value)
        
        if let key = name as? Key {
            if let property = variable as? Value {
                self[key] = property
            }
        }
    }
    
    /// Adds or sets the Grace Structure property to the given value.
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - value: The value of the property.
    mutating func setProperty(_ name:String, value:Float) {
        let variable = GraceVariable(name: name, value: value)
        
        if let key = name as? Key {
            if let property = variable as? Value {
                self[key] = property
            }
        }
    }
    
    /// Adds or sets the Grace Structure property to the given value.
    /// - Parameters:
    ///   - name: The name of the property.
    ///   - value: The value of the property.
    mutating func setProperty(_ name:String, value:String) {
        let variable = GraceVariable(name: name, value: value)
        
        if let key = name as? Key {
            if let property = variable as? Value {
                self[key] = property
            }
        }
    }
}

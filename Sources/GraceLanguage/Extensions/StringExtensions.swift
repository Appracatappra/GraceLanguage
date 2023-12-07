//
//  StringExtensions.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities

/// Extends the string class.
extension String {
    /// If `true`, the string contains a `Float` value.
    var isFloat:Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789.")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
    
    /// If `true`, the string contains an `Int` value.
    var isInt:Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
    
    /// If `true`, the string contains a `Bool` value.
    var isBool:Bool {
        switch self {
        case "true", "false":
            return true
        default:
            return false
        }
    }
    
    /// If `true`, the string contains a `void` value.
    var isVoid:Bool {
        if self == "void" {
            return true
        } else {
            return false
        }
    }
    
    /// if `true`, the string contains a `null` value.
    var isNull:Bool {
        if self == "null" {
            return true
        } else {
            return false
        }
    }
}

//
//  GraceRuntimeError.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/26/23.
//

import Foundation
import SwiftletUtilities

/// Defines the errors that can be thrown when executing a Grace program.
public enum GraceRuntimeError: Error {
    /// The requested variable was not found. `message` contains the details of the given failure.
    case unknownVariable(message: String)
    
    /// The requested function was not found. `message` contains the details of the given failure.
    case unknownFunction(message: String)
    
    /// A parameter was missing from a function call. `message` contains the details of the given failure.
    case missingParameter(message: String)
    
    /// Grace couldd not evaluate a formula. `message` contains the details of the given failure.
    case formulaError(message: String)
    
    /// The requested structure was not found. `message` contains the details of the given failure.
    case unknownStructure(message: String)
    
    /// The requested enumeration was not found. `message` contains the details of the given failure.
    case unknownEnumeration(message: String)
    
    /// The requested property was not found. `message` contains the details of the given failure.
    case unknownProperty(message: String)
    
    /// An array index was out of bounds. `message` contains the details of the given failure.
    case indexOutOfBounds(message: String)
    
    /// Grace was unable to process a given variable. `message` contains the details of the given failure.
    case variableError(message: String)
}

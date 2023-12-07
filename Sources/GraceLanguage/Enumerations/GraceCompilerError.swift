//
//  GraceCompilerError.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/29/23.
//

import Foundation
import SwiftletUtilities

/// Defines the errors that can be thrown when compiling a Grace program.
public enum GraceCompilerError: Error {
    /// The given keyword was invalid. `message` contains the details of the given failure.
    case invalidKeyword(message:String)
    
    /// The Grace program was not nested correctly. `message` contains the details of the given failure.
    case nestingError(message:String)
    
    /// The compiler was unable to process the given function. `message` contains the details of the given failure.
    case functionError(message:String)
    
    /// A Grace Instruction was malformed. `message` contains the details of the given failure.
    case malformedInstruction(message:String)
    
    /// An unknown library was calling in an import. `message` contains the details of the given failure.
    case unknownLibrary(message:String)
    
    /// The parameter type is invalid. `message` contains the details of the given failure.
    case invalidParameterType(message:String)
}

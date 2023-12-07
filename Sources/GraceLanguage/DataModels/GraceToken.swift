//
//  GraceToken.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/23/23.
//

import Foundation

/// Holds a token parsed out of a Grace Program.
public class GraceToken {
    
    // MARK: - Enumerations
    /// Defines the type of token.
    public enum tokenType {
        /// The token is empty.
        case empty
        
        /// The token contains an operand.
        case operand
        
        /// The token contains a double quoted string.
        case doubleQuotedString
        
        /// The token contains a single quoted string.
        case singleQuotedString
    }
    
    // MARK: - Properties
    /// The type of token.
    public var type:tokenType = .operand
    
    /// The value of the token.
    public var value:String = ""
    
    // MARK: - Initializers
    /// Creates a new empty instance.
    init() {
        self.type = .empty
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - type: The type of token.
    ///   - value: The value of the token.
    init(type: tokenType, value: String) {
        self.type = type
        self.value = value
    }
    
    /// Creates a new instance.
    /// - Parameter value: The value for the token.
    init(value:String) {
        self.value = value
    }
}

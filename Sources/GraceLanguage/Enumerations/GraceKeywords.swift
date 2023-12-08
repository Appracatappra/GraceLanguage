//
//  GraceKeywords.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/27/23.
//

import Foundation

/// Defines the list of Grace Keywords.
public enum GraceKeyword: String {
    case importKey = "import"
    case mainKey = "main"
    case varKey = "var"
    case letKey = "let"
    case nullKey = "null"
    case voidKey = "void"
    case anyKey = "any"
    case stringKey = "string"
    case boolKey = "bool"
    case intKey = "int"
    case floatKey = "float"
    case enumerationKey = "enumeration"
    case structureKey = "structure"
    case arrayKey = "array"
    case newKey = "new"
    case trueKey = "true"
    case falseKey = "false"
    case notKey = "not"
    case incrementKey = "increment"
    case decrementKey = "decrement"
    case addKey = "add"
    case toKey = "to"
    case atKey = "at"
    case indexKey = "index"
    case deleteKey = "delete"
    case fromKey = "from"
    case emptyKey = "empty"
    case iterateKey = "iterate"
    case inKey = "in"
    case forKey = "for"
    case ifKey = "if"
    case elseKey = "else"
    case whileKey = "while"
    case repeatKey = "repeat"
    case untilKey = "until"
    case switchKey = "switch"
    case caseKey = "case"
    case defaultKey = "default"
    case functionKey = "function"
    case returnsKey = "returns"
    case returnKey = "return"
    case callKey = "call"
    
    // MARK: - Special Parser Keywords
    case emptyStringKey = "EMPTY_STRING"
    case semicolon = ";"
    case colon = ":"
    case atSymbol = "@"
    case dollarSign = "$"
    case numberSymbol = "#"
    case openParenthesis = "("
    case closedParenthesis = ")"
    case openSquareBracket = "["
    case closedSquareBracket = "]"
    case openCurlyBracket = "{"
    case closedCurlyBracket = "}"
    case comma = ","
    case equal = "="
    case andSymbol = "&"
    case orSymbol = "|"
    case notEqual = "!="
    case lessThan = "<"
    case greaterThan = ">"
    case lessThanOrEqualTo = "<="
    case greaterThanOrEqualTo = ">="
    case plus = "+"
    case minus = "-"
    case asterisk = "*"
    case forwardSlash = "/"
    case tilda = "~"
    case unknown = "unknown"
    
    // MARK: - Static Functions
    /// Attempts to convert the given string value into a Grace keyword.
    /// - Parameter text: The string containing the possible keyword.
    /// - Returns: The matching `GraceKeyword` if found, else returns `nil`.
    static func get(fromString text: String) -> GraceKeyword? {
        
        // Is this an empty string?
        if text == "" {
            // Yes, return the semicolon to signify End-Of-Line.
            return .semicolon
        }
        
        return GraceKeyword(rawValue: text)
    }
}

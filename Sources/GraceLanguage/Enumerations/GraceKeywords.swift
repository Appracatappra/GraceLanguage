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
    
    // MARK: - Synonyms of other keywords
    case enumKey = "enum"
    case structKey = "struct"
    case variableKey = "variable"
    case defineKey = "define"
    case integerKey = "integer"
    case booleanKey = "boolean"
    case numberKey = "number"
    case trueFalseKey = "true_false"
    case yesNoKey = "yes_no"
    case yesKey = "yes"
    case noKey = "no"
    case funcKey = "func"
    case onKey = "on"
    case sendKey = "send"
    case beginKey = "begin"
    case endKey = "end"
    case asKey = "as"
    case equalKey = "equal"
    case equalsKey = "equals"
    case andKey = "and"
    case orKey = "or"
    case notEqualKey = "not_equal"
    case lessThanKey = "less_than"
    case greaterThanKey = "greater_than"
    case lessEqualKey = "less_or_equal"
    case greaterEqualKey = "greater_or_equal"
    case plusKey = "plus"
    case minusKey = "minus"
    case timesKey = "times"
    case divideKey = "divided_by"
    
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
        
        // Get keyword
        var key = GraceKeyword(rawValue: text)
        
        // Process any Synonyms and return the base key they represent.
        if let synonym = key {
            // Take action based on synonym
            switch synonym {
            case .enumKey:
                key = .enumerationKey
            case .structKey:
                key = .structureKey
            case .variableKey, .defineKey:
                key = .varKey
            case .integerKey:
                key = .integerKey
            case .booleanKey, .trueFalseKey, .yesNoKey:
                key = .boolKey
            case .numberKey:
                key = .floatKey
            case .yesKey:
                key = .trueKey
            case .noKey:
                key = .falseKey
            case .funcKey, .onKey:
                key = .functionKey
            case .sendKey:
                key = .callKey
            case .beginKey:
                key = .openCurlyBracket
            case .endKey:
                key = .closedCurlyBracket
            case .asKey:
                key = .colon
            case .equalKey, .equalsKey:
                key = .equal
            case .andKey:
                key = andSymbol
            case .orKey:
                key = .orSymbol
            case .notEqualKey:
                key = .notKey
            case .lessThanKey:
                key = .lessThan
            case .greaterThan:
                key = .greaterThan
            case .lessEqualKey:
                key = .lessThanOrEqualTo
            case .greaterEqualKey:
                key = .greaterThanOrEqualTo
            case .plusKey:
                key = .plus
            case .minusKey:
                key = .minus
            case .timesKey:
                key = .asterisk
            case .divideKey:
                key = .forwardSlash
                
            default:
                break
            }
        }
        
        // Returns found key.
        return key
    }
}

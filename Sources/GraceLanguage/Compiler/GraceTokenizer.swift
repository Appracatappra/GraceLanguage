//
//  ADscriptParseStack.swift
//  ActionControls
//
//  Created by Kevin Mullins on 10/19/17.
//  Copyright © 2017 Appracatappra, LLC. All rights reserved.
//

import Foundation

/// Holds the decomposed parts of a Grace Program command string while it is being parsed.
open class GraceTokenizer {
    
    // MARK: - Enumerations
    /// Defines the parser's state.
    public enum parserState {
        /// Seeking the start of a new keyword.
        case seekKey
        
        /// Parsing a current keyword.
        case inKeyword
        
        /// Parsing a single quoted value (').
        case inSingleQuote
        
        /// Parsing a double quoted value (").
        case inDoubleQuote
        
        /// Parsing an inline comment started by --. Everything to the end of the current line will be considered part of the comment.
        case inComment
    }
    
    // MARK: Static Properties
    /// A common, shared instance of the `ADscriptParseQueue` used across object instances.
    public nonisolated(unsafe) static let shared = GraceTokenizer()
    
    // MARK: - Properties
    /// An array of the decomposed parts of the script string
    public var queue: [GraceToken] = []
    
    /// Returns the number of elements initially parsed in the command string.
    public var count: Int {
        return queue.count
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    // MARK: - Functions
    /// Pushes a parsed element into the end of the queue.
    /// - Parameter element: An individual element parsed from the script command string to add to the queue.
    public func push(element: GraceToken) {
        queue.append(element)
    }
    
    /// Replaces the last element pushed into the queue with the given value.
    /// - Parameter element: The element value to replace the last one
    public func replaceLastElement(withElement element: GraceToken) {
        precondition(count > 0, "Empty parse queue.")
        queue[count - 1] = element
    }
    
    /// Removes the last element pushed into the parse queue.
    public func removeLastElement() {
        precondition(count > 0, "Empty parse queue.")
        queue.remove(at: count - 1)
    }
    
    /// Removes the top most element from the front of the queue.
    /// - Returns: The top most element from the parse queue.
    @discardableResult public func pop() -> GraceToken {
        precondition(count > 0, "Empty parse queue.")
        let element = queue.first
        queue.remove(at: 0)
        return element!
    }
    
    /// Returns the given element to the top of the queue.
    /// - Parameter element: The element to return
    public func replace(element:GraceToken) {
        queue.insert(element, at: 0)
    }
    
    /// Returns the next element that will be popped off the parse queue.
    /// - Returns: The next element that will be popped off the queue or an empth string ("") if an element doesn't exist.
    public func lookAhead() -> GraceToken {
        if count < 1 {
            return GraceToken()
        } else {
            return queue[0]
        }
    }
    
    /// Returns the last code segment that was being processed.
    /// - Returns: The code segment being processed.
    public func lastCodeSegment() -> String {
        var line:String = ""
        let start:Int = queue.count - 10
        
        for n in start..<queue.count {
            if (n < queue.count) && (n >= 0) {
                line = line + " \(queue[n].value)"
            }
        }
        
        return line
    }
    
    /// Parses the given script command into an array of decomposed elements stored in the parse queue.
    /// - Parameter script: The script command string to parse.
    public func parse(_ script: String) throws {
        var state: parserState = .seekKey
        var lastChar = ""
        var value = ""
        var key = ""
        var nestParenthesis = 0
        var nestSquareBrackets = 0
        var nestCurlyBrackets = 0
        var lineNumber:Int = 1
        var charPosition:Int = 0
        
        // Empty current queue
        queue = []
        
        // Process all characters in the script command
        for c in script {
            let char = String(c)
            charPosition += 1
            
            // Take action based on character and state.
            switch(char) {
            case " ", "\t":
                switch(state) {
                case .seekKey:
                    break
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    state = .seekKey
                    key = ""
                case .inComment:
                    break
                default:
                    value += char
                }
            case "\n", "\r":
                switch(state) {
                case .seekKey:
                    break
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    state = .seekKey
                    key = ""
                case .inComment:
                    value = ""
                    key = ""
                    state = .seekKey
                default:
                    value += char
                }
                lineNumber += 1
                charPosition = 0
            case "'":
                switch(state) {
                case .seekKey:
                    state = .inSingleQuote
                case .inSingleQuote:
                    if lastChar == "'" {
                        // Empty string?
                        if value.isEmpty {
                            push(element: GraceToken(type: .singleQuotedString, value: "EMPTY_STRING", row: lineNumber, col: charPosition))
                            value = ""
                            state = .seekKey
                        } else {
                            // Embedded single quote.
                            value += "'"
                            lastChar = ""
                        }
                    } else {
                        push(element: GraceToken(type: .singleQuotedString, value: value, row: lineNumber, col: charPosition))
                        value = ""
                        state = .seekKey
                    }
                case .inComment:
                    break
                default:
                    value += char
                }
            case "\"":
                switch(state) {
                case .seekKey:
                    state = .inDoubleQuote
                case .inDoubleQuote:
                    if lastChar == "\"" {
                        // Empty string?
                        if value.isEmpty {
                            push(element: GraceToken(type: .doubleQuotedString, value: "EMPTY_STRING", row: lineNumber, col: charPosition))
                            value = ""
                            state = .seekKey
                        } else {
                            // Embedded double quote.
                            value += "\""
                            lastChar = ""
                        }
                    } else {
                        push(element: GraceToken(type: .doubleQuotedString, value: value, row: lineNumber, col: charPosition))
                        value = ""
                        state = .seekKey
                    }
                case .inComment:
                    break
                default:
                    value += char
                }
            case "(":
                switch(state) {
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestParenthesis += 1
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestParenthesis += 1
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case ")":
                switch(state) {
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestParenthesis -= 1
                    if nestParenthesis < 0 {
                        throw GraceParseError.mismatchedParenthesis(message: "Parsing: \(lastCodeSegment())", row: lineNumber, col: charPosition)
                    }
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestParenthesis -= 1
                    if nestParenthesis < 0 {
                        throw GraceParseError.mismatchedParenthesis(message: "Parsing: \(lastCodeSegment())", row: lineNumber, col: charPosition)
                    }
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "[":
                switch(state) {
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestSquareBrackets += 1
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestSquareBrackets += 1
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "]":
                switch(state) {
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestSquareBrackets -= 1
                    if nestSquareBrackets < 0 {
                        throw GraceParseError.mismatchedSquareBracket(message: "Parsing: \(lastCodeSegment())", row: lineNumber, col: charPosition)
                    }
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestSquareBrackets -= 1
                    if nestSquareBrackets < 0 {
                        throw GraceParseError.mismatchedSquareBracket(message: "Parsing: \(lastCodeSegment())", row: lineNumber, col: charPosition)
                    }
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "{":
                switch(state) {
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestCurlyBrackets += 1
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestCurlyBrackets += 1
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "}":
                switch(state) {
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestCurlyBrackets -= 1
                    if nestCurlyBrackets < 0 {
                        throw GraceParseError.mismatchedCurlyBracket(message: "Parsing: \(lastCodeSegment())", row: lineNumber, col: charPosition)
                    }
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    nestCurlyBrackets -= 1
                    if nestCurlyBrackets < 0 {
                        throw GraceParseError.mismatchedCurlyBracket(message: "Parsing: \(lastCodeSegment())", row: lineNumber, col: charPosition)
                    }
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "*":
                switch(state){
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                case .inKeyword:
                    key += char
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    key = ""
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case ",", "+", "-", "!", ";", "<", ">", ":", "~", "@", "$", "#":
                switch(state){
                case .seekKey:
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                case .inKeyword:
                    push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                    push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    key = ""
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "=":
                switch(state){
                case .seekKey:
                    if lastChar == "!" {
                        replaceLastElement(withElement: GraceToken(value: "!=", row: lineNumber, col: charPosition))
                        lastChar = ""
                    } else if lastChar == "<" {
                        replaceLastElement(withElement: GraceToken(value: "<=", row: lineNumber, col: charPosition))
                        lastChar = ""
                    } else if lastChar == ">" {
                        replaceLastElement(withElement: GraceToken(value: ">=", row: lineNumber, col: charPosition))
                        lastChar = ""
                    } else {
                        push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    }
                    key = ""
                case .inKeyword:
                    if lastChar == "!" {
                        replaceLastElement(withElement: GraceToken(value: "!=", row: lineNumber, col: charPosition))
                        lastChar = ""
                    } else if lastChar == "<" {
                        replaceLastElement(withElement: GraceToken(value: "<=", row: lineNumber, col: charPosition))
                        lastChar = ""
                    } else if lastChar == ">" {
                        replaceLastElement(withElement: GraceToken(value: ">=", row: lineNumber, col: charPosition))
                        lastChar = ""
                    } else {
                        push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                        push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    }
                    key = ""
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            case "/":
                switch(state){
                case .seekKey:
                    if lastChar == "/" {
                        state = .inComment
                        removeLastElement()
                        lastChar = ""
                    } else {
                        push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    }
                    key = ""
                case .inKeyword:
                    if lastChar == "/" {
                        state = .inComment
                        removeLastElement()
                        lastChar = ""
                    } else {
                        push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
                        push(element: GraceToken(value: char, row: lineNumber, col: charPosition))
                    }
                    key = ""
                    state = .seekKey
                case .inComment:
                    break
                default:
                    value += char
                }
            default:
                switch(state) {
                case .seekKey:
                    key += char
                    state = .inKeyword
                case .inKeyword:
                    key += char
                case .inComment:
                    break
                default:
                    value += char
                }
            }
            
            lastChar = char
        }
        
        // Validate terminating state
        switch (state) {
        case .inSingleQuote:
            throw GraceParseError.mismatchedSingleQuotes(message: "Parsing Section: \(lastCodeSegment())", row: lineNumber, col: charPosition)
        case .inDoubleQuote:
            throw GraceParseError.mismatchedDoubleQuotes(message: "Parsing Section: \(lastCodeSegment())", row: lineNumber, col: charPosition)
        default:
            if nestParenthesis > 0 {
                throw GraceParseError.mismatchedParenthesis(message: "Parsing Section: \(lastCodeSegment())", row: lineNumber, col: charPosition)
            }
            
            if nestSquareBrackets > 0 {
                throw GraceParseError.mismatchedSquareBracket(message: "Parsing Section: \(lastCodeSegment())", row: lineNumber, col: charPosition)
            }
            
            if nestCurlyBrackets > 0 {
                throw GraceParseError.mismatchedCurlyBracket(message: "Parsing Section: \(lastCodeSegment())", row: lineNumber, col: charPosition)
            }
        }
        
        // Handle any trailing values
        if !key.isEmpty {
            push(element: GraceToken(value: key, row: lineNumber, col: charPosition))
        }
        
        if !value.isEmpty {
            push(element: GraceToken(value: value, row: lineNumber, col: charPosition))
        }
    }
}

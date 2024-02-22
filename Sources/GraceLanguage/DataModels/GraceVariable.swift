//
//  GraceVariable.swift
//  GraceBuilder
//
//  Created by Kevin Mullins on 11/25/23.
//

import Foundation
import SwiftletUtilities
import SimpleSerializer

/// Holds the value and information about a `GraceVariable`.
open class GraceVariable {
    
    // MARK: - Static Computed Properties
    /// Returns a `void` `GraceVariable`.
    public static var void:GraceVariable {
        return GraceVariable(name: "void", value: "", type: .void)
    }
    
    /// Returns a `null GraceVariable`.
    public static var null:GraceVariable {
        return GraceVariable(name: "null", value: "", type: .null)
    }
    
    /// Returns a `GraceVariable` containing an empty string.
    public static var emptyString:GraceVariable {
        return GraceVariable(name: "empty", value: "", type: .string)
    }
    
    // MARK: - Enumerations
    /// Defines the type of a `GraceVariable`.
    public enum VariableType {
        /// A `null` variable.
        case null
        
        /// A `void` variable.
        case void
        
        /// A variable that can hold any value.
        case any
        
        /// A string value.
        case string
        
        /// A `true` or `false` value.
        case bool
        
        /// A integer value.
        case int
        
        /// A float value.
        case float
        
        /// A `GraceEnumeration`.
        case enumeration
        
        /// A `GraceStructure`.
        case structure
        
        /// Sets the type from a string.
        /// - Parameter value: The value representing the type.
        public mutating func from(_ value:String) {
            switch value {
            case "null":
                self = .null
            case "any":
                self = .any
            case "string":
                self = .string
            case "bool":
                self = .bool
            case "int":
                self = .int
            case "float":
                self = .float
            case "enumeration":
                self = .enumeration
            case "structure":
                self = .structure
            default:
                self = .void
            }
        }
    }
    
    // MARK: - Properties
    /// The variable name.
    public var name:String = ""
    
    /// The raw values that are backing the variable.
    public var rawValue:[String] = [""]
    
    /// The type of variable.
    public var type:VariableType = .null
    
    /// If `true`, the variable contains a `GraceArray`.
    public var isArray:Bool = false
    
    /// If the variable is an enumeration or structure, this is the `GraceEnumeration` or `GraceStructure` name.
    public var subtypeName:String = ""
    
    // MARK: - Computed Properties
    /// For `GraceArrays`, returns the number of items in the array.
    public var count:Int {
        return rawValue.count
    }
    
    /// Returns the length of the value being stored.
    public var length:Int {
        return rawValue[0].count
    }
    
    /// Gets or sets the value as a string.
    public var string:String {
        get {
            // Handle an empty string marker from the tokenizer.
            if rawValue[0] == GraceKeyword.emptyStringKey.rawValue {
                return ""
            } else {
                return rawValue[0]
            }
        }
        set {
            rawValue[0] = newValue
        }
    }
    
    /// Gets or sets the value as a boolean.
    public var bool:Bool {
        get {
            if let b = Bool(rawValue[0]) {
                return b
            } else {
                return false
            }
        }
        set {
            rawValue[0] = "\(newValue)"
        }
    }
    
    /// Gets or sets the value as an integer.
    public var int:Int {
        get {
            if let i = Int(rawValue[0]) {
                return i
            } else {
                return 0
            }
        }
        set {
            rawValue[0] = "\(newValue)"
        }
    }
    
    /// Gets or sets the value as a float.
    public var float:Float {
        get {
            if let f = Float(rawValue[0]) {
                return f
            } else {
                return 0
            }
        }
        set {
            rawValue[0] = "\(newValue)"
        }
    }
    
    /// Returns `true` if the value being held is float data.
    public var isFloat:Bool {
        let value = rawValue[0]
        return value.isFloat
    }
    
    /// Returns `true` if the value being held is int data.
    public var isInt:Bool {
        let value = rawValue[0]
        return value.isInt
    }
    
    /// Returns `true` if the value being held is bool data.
    public var isBool:Bool {
        let value = rawValue[0]
        return value.isBool
    }
    
    /// Returns `true` if the value being held is null data.
    public var isNull:Bool {
        let value = rawValue[0]
        return value.isNull
    }
    
    /// Returns `true` if the value being held is void data.
    public var isVoid:Bool {
        let value = rawValue[0]
        return value.isVoid
    }
    
    /// Returns `true` if the value being held is string data.
    public var isString:Bool {
        let value = rawValue[0]
        return value.isContiguousUTF8
    }
    
    /// Returns `true` if the value being held is empty
    public var isEmpty:Bool {
        let value = rawValue[0]
        return value.isEmpty
    }
    
    // MARK: - Initializers
    /// Creates a new instance.
    public init() {
        
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - name: The name of the variable.
    ///   - value: The default boolean value.
    public init(name:String, value:Bool) {
        self.name = name
        self.rawValue[0] = "\(value)"
        self.type = .bool
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - name: The name of the variable.
    ///   - value: The default integer value.
    public init(name:String, value:Int) {
        self.name = name
        self.rawValue[0] = "\(value)"
        self.type = .int
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - name: The name of the variable.
    ///   - value: The default float value.
    public init(name:String, value:Float) {
        self.name = name
        self.rawValue[0] = "\(value)"
        self.type = .float
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - name: The name of the variable.
    ///   - value: The default value as a string.
    ///   - type: The type of the variable.
    public init(name:String, value:String, type:VariableType? = nil) {
        
        self.name = name
        self.rawValue[0] = value
        
        if let type {
            self.type = type
        } else {
            // Determine type from the data held in the value.
            if value.isFloat {
                self.type = .float
            } else if value.isInt {
                self.type = .int
            } else if value.isBool {
                self.type = .bool
            } else if value.isNull {
                self.type = .null
            } else if value.isVoid {
                self.type = .void
            } else {
                // Default to string.
                self.type = .string
            }
        }
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - name: The name of the variable.
    ///   - value: An array of default string values.
    ///   - type: The type of the variable.
    public init(name:String, value:[String], type:VariableType = .void) {
        
        self.name = name
        self.rawValue = value
        
        if type != .void {
            self.type = type
            return
        }
        
        guard value.count > 0 else {
            self.type = .any
            return
        }
        
        if value[0].isFloat {
            self.type = .float
        } else if value[0].isInt {
            self.type = .int
        } else if value[0].isBool {
            self.type = .bool
        } else {
            self.type = .string
        }
    }
    
    /// Creates a new instance.
    /// - Parameters:
    ///   - name: The name of the variable.
    ///   - rawValue: The default raw values.
    ///   - type: The type of the variable.
    ///   - isArray: If `true`, the variable contains a `GraceArray`.
    ///   - subtypeName: If the variable is an enumeration or structure, this is the `GraceEnumeration` or `GraceStructure` name.
    public init(name: String, rawValue: [String], type: VariableType, isArray: Bool, subtypeName: String) {
        self.name = name
        self.rawValue = rawValue
        self.type = type
        self.isArray = isArray
        self.subtypeName = subtypeName
    }
    
    // MARK: - Functions
    /// Creates a clone of the variable.
    /// - Returns: Returns a variable clone.
    public func clone() -> GraceVariable {
        let copy:GraceVariable = GraceVariable()
        
        copy.name = self.name
        copy.type = self.type
        copy.isArray = self.isArray
        copy.subtypeName = self.subtypeName
        
        copy.rawValue = []
        for value in self.rawValue {
            copy.rawValue.append(value)
        }
        
        return copy
    }
    
    /// Atuomaticlaly select the variable type based on the data that it holds.
    public func autoCastType() {
        let value = rawValue[0]
        
        // Determine type from the data held in the value.
        if value.isFloat {
            type = .float
        } else if value.isInt {
            type = .int
        } else if value.isBool {
           type = .bool
        } else if value.isNull {
            type = .null
        } else if value.isVoid {
            type = .void
        } else {
            // Default to string.
            type = .string
        }
    }
    
    /// Casts the variable to a float.
    public func toFloat() {
        type = .float
    }
    
    /// Casts the variable to an int.
    public func toInt() {
        type = .int
    }
    
    /// Casts the variable to a bool.
    public func toBool() {
        type = .bool
    }
    
    /// Casts the variable to a  string.
    public func toString() {
        type = .string
    }
    
    /// Gets the string value at the given index.
    /// - Parameter index: The index to return.
    /// - Returns: Returns the requested item.
    public func string(_ index:Int) -> String {
        
        guard index >= 0 && index < count else {
            return ""
        }
        
        // Handle an empty string token being returned from the tokenizer.
        if rawValue[index] == GraceKeyword.emptyStringKey.rawValue {
            return ""
        } else {
            return rawValue[index]
        }
    }
    
    /// Gets the boolean value at the given index.
    /// - Parameter index: The index to return.
    /// - Returns: Returns the requested item.
    public func bool(_ index:Int) -> Bool {
        
        guard index >= 0 && index < count else {
            return false
        }
        
        if let b = Bool(rawValue[index]) {
            return b
        } else {
            return false
        }
    }
    
    /// Gets the integer value at the given index.
    /// - Parameter index: The index to return.
    /// - Returns: Returns the requested item.
    public func int(_ index:Int) -> Int {
        
        guard index >= 0 && index < count else {
            return 0
        }
        
        if let i = Int(rawValue[index]) {
            return i
        } else {
            return 0
        }
    }
    
    /// Gets the float value at the given index.
    /// - Parameter index: The index to return.
    /// - Returns: Returns the requested item.
    public func float(_ index:Int) -> Float {
        
        guard index >= 0 && index < count else {
            return 0
        }
        
        if let f = Float(rawValue[index]) {
            return f
        } else {
            return 0
        }
    }
    
    /// Empties the variable.
    public func clear() {
        rawValue = [""]
    }
    
    /// Removes the item at the given index.
    /// - Parameter index: The index to remove.
    public func remove(at index:Int) {
        guard index >= 0 && index < count else {
            return
        }
        
        rawValue.remove(at: index)
    }
    
    /// Appends a value to the array.
    /// - Parameter value: The value to append.
    public func append(_ value:String) {
        rawValue.append(value)
    }
    
    /// Appends a value to the array.
    /// - Parameter value: The value to append.
    public func append(_ value:Bool) {
        rawValue.append("\(value)")
    }
    
    /// Appends a value to the array.
    /// - Parameter value: The value to append.
    public func append(_ value:Int) {
        rawValue.append("\(value)")
    }
    
    /// Appends a value to the array.
    /// - Parameter value: The value to append.
    public func append(_ value:Float) {
        rawValue.append("\(value)")
    }
    
    /// Inserts an item in the array at the given index.
    /// - Parameters:
    ///   - value: The item to insert.
    ///   - index: The index to insert the item at.
    public func insert(_ value:String, at index:Int) {
        guard index >= 0 && index < count else {
            append(value)
            return
        }
        
        rawValue.insert(value, at: index)
    }
    
    /// Inserts an item in the array at the given index.
    /// - Parameters:
    ///   - value: The item to insert.
    ///   - index: The index to insert the item at.
    public func insert(_ value:Bool, at index:Int) {
        let element = "\(value)"
        
        guard index >= 0 && index < count else {
            append(element)
            return
        }
        
        rawValue.insert(element, at: index)
    }
    
    /// Inserts an item in the array at the given index.
    /// - Parameters:
    ///   - value: The item to insert.
    ///   - index: The index to insert the item at.
    public func insert(_ value:Int, at index:Int) {
        let element = "\(value)"
        
        guard index >= 0 && index < count else {
            append(element)
            return
        }
        
        rawValue.insert(element, at: index)
    }
    
    /// Inserts an item in the array at the given index.
    /// - Parameters:
    ///   - value: The item to insert.
    ///   - index: The index to insert the item at.
    public func insert(_ value:Float, at index:Int) {
        let element = "\(value)"
        
        guard index >= 0 && index < count else {
            append(element)
            return
        }
        
        rawValue.insert(element, at: index)
    }
}

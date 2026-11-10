//
//  File.swift
//  GraceLanguage
//
//  Created by Kevin Mullins on 11/10/26.
//

import Foundation
import LogManager
import SwiftletUtilities

public extension GraceCompiler {
    /// Imports the string library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    internal func ImportStringLibrary(to executable:GraceExecutable) {
        
        // Add format.
        executable.register(name: "format", parameterNames: ["text", "elements"], parameterTypes: [.string, .any], returnType: .string) { parameters in
            var result:String = ""
            
            guard let text = parameters["text"] else {
                return GraceVariable.emptyString
            }
            
            guard let elements = parameters["elements"] else {
                return text
            }
            
            result = text.string
            for n in 0..<elements.count {
                result.replace("{\(n)}", with: elements.string(n))
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add char.
        executable.register(name: "char", parameterNames: ["text", "index"], parameterTypes: [.string, .int], returnType: .string) { parameters in
            var char:String = ""
            
            if let text = parameters["text"] {
                if let index = parameters["index"] {
                    char = "\(text.string[index.int])"
                }
            }
            
            return GraceVariable(name: "result", value: char, type: .string)
        }
        
        // Add length.
        executable.register(name: "length", parameterNames: ["text"], parameterTypes: [.string], returnType: .int) { parameters in
            var length:Int = 0
            
            if let text = parameters["text"] {
                length = text.count
            }
            
            return GraceVariable(name: "result", value: "\(length)", type: .int)
        }
        
        // Add contains.
        executable.register(name: "stringContains", parameterNames: ["text", "pattern"], parameterTypes: [.string, .string], returnType: .bool) { parameters in
            var found:Bool = false
            
            if let text = parameters["text"] {
                if let pattern = parameters["pattern"] {
                    found = text.string.contains(pattern.string)
                }
            }
            
            return GraceVariable(name: "result", value: "\(found)", type: .bool)
        }
        
        // Add replace
        executable.register(name: "replace", parameterNames: ["text", "item", "newValue"], parameterTypes: [.string, .string, .string]) { parameters in
            
            if let text = parameters["text"] {
                if let item = parameters["item"] {
                    if let newValue = parameters["newValue"] {
                        text.string = text.string.replacing(item.string, with: newValue.string)
                    }
                }
            }
            
            return nil
        }
        
        // Add concat
        executable.register(name: "concat", parameterNames: ["text", "item", "delimiter"], parameterTypes: [.string, .string, .string]) { parameters in
            
            if let text = parameters["text"] {
                if let item = parameters["item"] {
                    if let delimiter = parameters["delimiter"] {
                        if text.string == "" {
                            text.string = item.string
                        } else {
                            text.string = "\(text.string)\(delimiter.string)\(item.string)"
                        }
                    }
                }
            }
            
            return nil
        }
        
        // Add upper cased.
        executable.register(name: "uppercase", parameterNames: ["text"], parameterTypes: [.string]) { parameters in
            
            if let text = parameters["text"] {
                text.string = text.string.uppercased()
            }
            
            return nil
        }
        
        // Add lower cased.
        executable.register(name: "lowercase", parameterNames: ["text"], parameterTypes: [.string]) { parameters in
            
            if let text = parameters["text"] {
                text.string = text.string.lowercased()
            }
            
            return nil
        }
        
        // Add title case.
        executable.register(name: "titlecase", parameterNames: ["text"], parameterTypes: [.string]) { parameters in
            
            if let text = parameters["text"] {
                text.string = text.string.titlecased()
            }
            
            return nil
        }
        
        // Add split string.
        executable.register(name: "split", parameterNames: ["text", "pattern"], parameterTypes: [.string, .string], returnType: .string) { parameters in
            var parts:[String] = []
            
            if let text = parameters["text"] {
                if let pattern = parameters["pattern"] {
                    let elements = text.string.split(separator: pattern.string)
                    for element in elements {
                        parts.append("\(element)")
                    }
                }
            }
            
            let result = GraceVariable()
            result.name = "result"
            result.rawValue = parts
            result.type = .string
            result.isArray = true
            
            return result
        }
        
        // Add left string.
        executable.register(name: "leftString", parameterNames: ["text", "length"], parameterTypes: [.string, .int], returnType: .string) { parameters in
            var result:String = ""
            var count:Int = 0
            
            if let text = parameters["text"] {
                if let length = parameters["length"] {
                    for char in text.string {
                        if count >= length.int {
                            break
                        } else {
                            result += "\(char)"
                        }
                        count += 1
                    }
                }
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add right string.
        executable.register(name: "rightString", parameterNames: ["text", "length"], parameterTypes: [.string, .int], returnType: .string) { parameters in
            var result:String = ""
            
            if let text = parameters["text"] {
                let max = text.count - 1
                if let length = parameters["length"] {
                    var min = max - length.int
                    if min < 0 {
                        min = 0
                    }
                    for n in min...max {
                        result += "\(text.string[n])"
                    }
                }
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add mid string.
        executable.register(name: "midString", parameterNames: ["text", "start", "length"], parameterTypes: [.string, .int, .int], returnType: .string) { parameters in
            var result:String = ""
            
            if let text = parameters["text"] {
                if let start = parameters["start"] {
                    if let length = parameters["length"] {
                        var min = start.int
                        if min < 0 {
                            min = 0
                        }
                        
                        var max = min + length.int
                        if max > text.string.count {
                            max = text.string.count
                        }
                        
                        for n in min...max {
                            result += "\(text.string[n])"
                        }
                    }
                }
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
    }
}

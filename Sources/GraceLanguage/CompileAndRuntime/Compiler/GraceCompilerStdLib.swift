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
    /// Imports the standard library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    internal func ImportStandardLibrary(to executable:GraceExecutable) {
        
        // Add print
        executable.register(name: "print", parameterNames: ["message"], parameterTypes: [.any]) { parameters in
            
            if let message = parameters["message"] {
                Debug.info(subsystem: "Grace Runtime", category: "Print", message.string)
            }
            
            return nil
        }
        
        // Add formatted print
        executable.register(name: "printf", parameterNames: ["text", "elements"], parameterTypes: [.string, .any]) { parameters in
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
            
            Debug.info(subsystem: "Grace Runtime", category: "Print", result)
            
            return nil
        }
        
        // Add negateInt.
        executable.register(name: "negateInt", parameterNames: ["value"], parameterTypes: [.any], returnType: .int) { parameters in
            var result:Int = 0
            
            if let value = parameters["value"] {
                result = 0 - value.int
            }
            
            return GraceVariable(name: "result", value: "\(result)", type: .int)
        }
        
        // Add negateInt.
        executable.register(name: "negateFloat", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            var result:Float = 0
            
            if let value = parameters["value"] {
                result = 0 - value.float
            }
            
            return GraceVariable(name: "result", value: "\(result)", type: .float)
        }
        
        // Add toString.
        executable.register(name: "toString", parameterNames: ["value"], parameterTypes: [.any], returnType: .string) { parameters in
            var result:String = ""
            
            if let value = parameters["value"] {
                result = value.string
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add toBool.
        executable.register(name: "toBool", parameterNames: ["value"], parameterTypes: [.any], returnType: .bool) { parameters in
            var result:Bool = false;
            
            if let value = parameters["value"] {
                result = value.bool
            }
            
            return GraceVariable(name: "result", value: "\(result)", type: .bool)
        }
        
        // Add toInt.
        executable.register(name: "toInt", parameterNames: ["value"], parameterTypes: [.any], returnType: .int) { parameters in
            var result:Int = 0;
            
            if let value = parameters["value"] {
                result = value.int
            }
            
            return GraceVariable(name: "result", value: "\(result)", type: .int)
        }
        
        // Add toInt.
        executable.register(name: "toFloat", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            var result:Float = 0;
            
            if let value = parameters["value"] {
                result = value.float
            }
            
            return GraceVariable(name: "result", value: "\(result)", type: .float)
        }
        
        // Add array item count.
        executable.register(name: "count", parameterNames: ["array"], parameterTypes: [.any], returnType: .int) { parameters in
            var length:Int = 0
            
            if let array = parameters["array"] {
                length = array.count
            }
            
            return GraceVariable(name: "result", value: "\(length)", type: .int)
        }
        
        // Add random number generator.
        executable.register(name: "random", parameterNames: ["from", "to"], parameterTypes: [.int, .int], returnType: .int) { parameters in
            var value:Int = 0
            
            if let from = parameters["from"] {
                if let to = parameters["to"] {
                    value = Int.random(in: from.int...to.int)
                }
            }
            
            return GraceVariable(name: "result", value: "\(value)", type: .int)
        }
        
        // Add Array Contains
        executable.register(name: "arrayContains", parameterNames: ["array", "element"], parameterTypes: [.any, .any], returnType: .bool) { parameters in
            var found:Bool = false
            
            if let array = parameters["array"] {
                if let element = parameters["element"] {
                    for n in 0..<array.count {
                        if array.string(n) == element.string {
                            found = true
                            break
                        }
                    }
                }
            }
            
            return GraceVariable(name: "result", value: "\(found)", type: .bool)
        }
    }
}

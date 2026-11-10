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
    
    /// Imports the macro library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    internal func ImportMacroLibrary(to executable:GraceExecutable) {
        
        // Add `If` function.
        executable.register(name: "if", parameterNames: ["condition", "isTrue", "isFalse"], parameterTypes: [.bool, .any, .any], returnType: .string) { parameters in
            var result:String = ""
            
            if let condition = parameters["condition"] {
                if condition.bool {
                    if let text = parameters["isTrue"] {
                        result = text.string
                    } else {
                        result = "**@IF ERROR**"
                    }
                } else {
                    if let text = parameters["isFalse"] {
                        result = text.string
                    }
                }
            } else {
                result = "**@IF ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `randomString` function.
        executable.register(name: "randomString", parameterNames: ["items"], parameterTypes: [.string], returnType: .string) { parameters in
            var result:String = ""
            
            if let items = parameters["items"] {
                let index = Int.random(in: 0..<items.count)
                result = items.string(index)
            } else {
                result = "**@RANDOMSTRING ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `selectString` function.
        executable.register(name: "selectString", parameterNames: ["part", "items"], parameterTypes: [.int ,.string], returnType: .string) { parameters in
            var result:String = ""
            
            if let part = parameters["part"] {
                if let items = parameters["items"] {
                    var index = part.int
                    if index < 0 || index >= items.count {
                        index = 0
                    }
                    result = items.string(index)
                } else {
                    result = "**@SELECTSTRING ERROR**"
                }
            } else {
                result = "**@SELECTSTRING ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `intMath` function.
        executable.register(name: "intMath", parameterNames: ["operandA", "operation", "operandB"], parameterTypes: [.int, .string, .int], returnType: .int) { parameters in
            let result:GraceVariable = GraceVariable(name: "result", value: "0", type: .int)
            
            if let operandA = parameters["operandA"] {
                if let operation = parameters["operation"] {
                    if let operandB = parameters["operandB"] {
                        switch operation.string {
                        case "+":
                            result.int = operandA.int + operandB.int
                        case "-":
                            result.int = operandA.int - operandB.int
                        case "*":
                            result.int = operandA.int * operandB.int
                        case "/":
                            result.int = operandA.int / operandB.int
                        default:
                            result.string = "**@INTMATH ERROR: \(operation.string)**"
                        }
                    } else {
                        result.string = "**@INTMATH ERROR: operandB**"
                    }
                } else {
                    result.string = "**@INTMATH ERROR: operation**"
                }
            } else {
                result.string = "**@INTMATH ERROR: operandA**"
            }
            
            return result
        }
        
        // Add `intMath` function.
        executable.register(name: "floatMath", parameterNames: ["operandA", "operation", "operandB"], parameterTypes: [.float, .string, .float], returnType: .float) { parameters in
            let result:GraceVariable = GraceVariable(name: "result", value: "0", type: .float)
            
            if let operandA = parameters["operandA"] {
                if let operation = parameters["operation"] {
                    if let operandB = parameters["operandB"] {
                        switch operation.string {
                        case "+":
                            result.float = operandA.float + operandB.float
                        case "-":
                            result.float = operandA.float - operandB.float
                        case "*":
                            result.float = operandA.float * operandB.float
                        case "/":
                            result.float = operandA.float / operandB.float
                        default:
                            result.string = "**@INTMATH ERROR: \(operation)**"
                        }
                    } else {
                        result.string = "**@INTMATH ERROR: operandB**"
                    }
                } else {
                    result.string = "**@INTMATH ERROR: operation**"
                }
            } else {
                result.string = "**@INTMATH ERROR: operandA**"
            }
            
            return result
        }
        
        // Add `formatFloat` function.
        executable.register(name: "formatFloat", parameterNames: ["number"], parameterTypes: [.float], returnType: .float) { parameters in
            var result:String = ""
            
            if let number = parameters["number"] {
                let value = number.float
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let formattedNumber = numberFormatter.string(from: NSNumber(value:value)) {
                    result = formattedNumber
                } else {
                    result = "**@FORMATFLOAT ERROR**"
                }
            } else {
                result = "**@FORMATFLOAT ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
        
        // Add `expandMacros` function.
        executable.register(name: "expandMacros", parameterNames: ["text"], parameterTypes: [.string], returnType: .string) { parameters in
            var result:String = ""
            
            if let text = parameters["text"] {
                do {
                    result = try GraceRuntime.shared.expandMacros(in: text.string)
                } catch {
                    result = "**@EXPANDMACROS ERROR: \(error)**"
                }
            } else {
                result = "**@EXPANDMACROS ERROR**"
            }
            
            return GraceVariable(name: "result", value: result, type: .string)
        }
    }
}

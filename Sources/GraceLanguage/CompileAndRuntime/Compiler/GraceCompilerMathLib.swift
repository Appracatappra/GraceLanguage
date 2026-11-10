//
//  GraceCompilerMathLib.swift
//  GraceLanguage
//
//  Created by Kevin Mullins on 11/10/26.
//

import Foundation

private func mathFloatResult(_ value: Float) -> GraceVariable {
    GraceVariable(name: "result", value: value)
}

private func mathIntegerResult(_ value: Int) -> GraceVariable {
    GraceVariable(name: "result", value: value)
}

private func mathBooleanResult(_ value: Bool) -> GraceVariable {
    GraceVariable(name: "result", value: value)
}

private func mathStringResult(_ value: String) -> GraceVariable {
    GraceVariable(name: "result", value: value, type: .string)
}

public extension GraceCompiler {

    /// Imports the standard math library into the given `GraceExecutable`.
    /// - Parameter executable: The `GraceExecutable` to import the library into.
    internal func ImportMathLibrary(to executable:GraceExecutable) {
        // MARK: Constants
        executable.register(name: "pi", returnType: .float) { _ in
            mathFloatResult(.pi)
        }

        executable.register(name: "e", returnType: .float) { _ in
            mathFloatResult(Float(M_E))
        }

        executable.register(name: "positiveInfinity", returnType: .float) { _ in
            mathFloatResult(.infinity)
        }

        executable.register(name: "negativeInfinity", returnType: .float) { _ in
            mathFloatResult(-.infinity)
        }

        executable.register(name: "notANumber", returnType: .float) { _ in
            mathFloatResult(.nan)
        }

        // MARK: Arithmetic
        executable.register(name: "absoluteValue", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(abs(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "remainder", parameterNames: ["value", "divisor"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(fmodf(parameters["value"]?.float ?? 0, parameters["divisor"]?.float ?? 0))
        }

        executable.register(name: "ieeeRemainder", parameterNames: ["value", "divisor"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(remainderf(parameters["value"]?.float ?? 0, parameters["divisor"]?.float ?? 0))
        }

        executable.register(name: "minimum", parameterNames: ["a", "b"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(fminf(parameters["a"]?.float ?? 0, parameters["b"]?.float ?? 0))
        }

        executable.register(name: "maximum", parameterNames: ["a", "b"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(fmaxf(parameters["a"]?.float ?? 0, parameters["b"]?.float ?? 0))
        }

        executable.register(name: "positiveDifference", parameterNames: ["a", "b"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(fdimf(parameters["a"]?.float ?? 0, parameters["b"]?.float ?? 0))
        }

        executable.register(name: "copySign", parameterNames: ["magnitude", "sign"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(copysignf(parameters["magnitude"]?.float ?? 0, parameters["sign"]?.float ?? 0))
        }

        // MARK: Powers and Roots
        executable.register(name: "power", parameterNames: ["base", "exponent"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(powf(parameters["base"]?.float ?? 0, parameters["exponent"]?.float ?? 0))
        }

        executable.register(name: "square", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            let value = parameters["value"]?.float ?? 0
            return mathFloatResult(value * value)
        }

        executable.register(name: "cube", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            let value = parameters["value"]?.float ?? 0
            return mathFloatResult(value * value * value)
        }

        executable.register(name: "squareRoot", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(sqrtf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "cubeRoot", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(cbrtf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "hypotenuse", parameterNames: ["x", "y"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(hypotf(parameters["x"]?.float ?? 0, parameters["y"]?.float ?? 0))
        }

        // MARK: Exponents and Logarithms
        executable.register(name: "naturalExponent", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(expf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "powerOfTwo", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(exp2f(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "naturalExponentMinusOne", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(expm1f(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "naturalLog", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(logf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "baseTwoLog", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(log2f(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "baseTenLog", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(log10f(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "naturalLogPlusOne", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(log1pf(parameters["value"]?.float ?? 0))
        }

        // MARK: Trigonometry
        executable.register(name: "sine", parameterNames: ["radians"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(sinf(parameters["radians"]?.float ?? 0))
        }

        executable.register(name: "cosine", parameterNames: ["radians"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(cosf(parameters["radians"]?.float ?? 0))
        }

        executable.register(name: "tangent", parameterNames: ["radians"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(tanf(parameters["radians"]?.float ?? 0))
        }

        executable.register(name: "inverseSine", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(asinf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "inverseCosine", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(acosf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "inverseTangent", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(atanf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "angleFromCoordinates", parameterNames: ["vertical", "horizontal"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(atan2f(parameters["vertical"]?.float ?? 0, parameters["horizontal"]?.float ?? 0))
        }

        executable.register(name: "degreesToRadians", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult((parameters["value"]?.float ?? 0) * .pi / 180)
        }

        executable.register(name: "radiansToDegrees", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult((parameters["value"]?.float ?? 0) * 180 / .pi)
        }

        // MARK: Rounding
        executable.register(name: "roundUp", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(ceilf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "roundDown", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(floorf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "round", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(roundf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "truncate", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(truncf(parameters["value"]?.float ?? 0))
        }

        executable.register(name: "roundToInteger", parameterNames: ["value"], parameterTypes: [.any], returnType: .int) { parameters in
            let rounded = roundf(parameters["value"]?.float ?? 0)
            guard rounded.isFinite, rounded >= Float(Int.min), rounded < Float(Int.max) else {
                return mathIntegerResult(0)
            }
            return mathIntegerResult(Int(rounded))
        }

        // MARK: Floating-Point Inspection
        executable.register(name: "isFinite", parameterNames: ["value"], parameterTypes: [.any], returnType: .bool) { parameters in
            mathBooleanResult((parameters["value"]?.float ?? 0).isFinite)
        }

        executable.register(name: "isInfinite", parameterNames: ["value"], parameterTypes: [.any], returnType: .bool) { parameters in
            mathBooleanResult((parameters["value"]?.float ?? 0).isInfinite)
        }

        executable.register(name: "isNotANumber", parameterNames: ["value"], parameterTypes: [.any], returnType: .bool) { parameters in
            mathBooleanResult((parameters["value"]?.float ?? 0).isNaN)
        }

        executable.register(name: "isNormal", parameterNames: ["value"], parameterTypes: [.any], returnType: .bool) { parameters in
            mathBooleanResult((parameters["value"]?.float ?? 0).isNormal)
        }

        executable.register(name: "isNegative", parameterNames: ["value"], parameterTypes: [.any], returnType: .bool) { parameters in
            mathBooleanResult((parameters["value"]?.float ?? 0).sign == .minus)
        }

        executable.register(name: "classifyNumber", parameterNames: ["value"], parameterTypes: [.any], returnType: .string) { parameters in
            let value = parameters["value"]?.float ?? 0
            let classification:String

            if value.isNaN {
                classification = "notANumber"
            } else if value.isInfinite {
                classification = "infinite"
            } else if value.isZero {
                classification = "zero"
            } else if value.isSubnormal {
                classification = "subnormal"
            } else {
                classification = "normal"
            }

            return mathStringResult(classification)
        }

        // MARK: Floating-Point Representation
        executable.register(name: "nextValueToward", parameterNames: ["value", "direction"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            let value = parameters["value"]?.float ?? 0
            let direction = parameters["direction"]?.float ?? 0

            if value.isNaN || direction.isNaN {
                return mathFloatResult(.nan)
            } else if value == direction {
                return mathFloatResult(direction)
            } else if direction > value {
                return mathFloatResult(value.nextUp)
            } else {
                return mathFloatResult(value.nextDown)
            }
        }

        executable.register(name: "scaleByPowerOfTwo", parameterNames: ["value", "exponent"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(scalbnf(parameters["value"]?.float ?? 0, Int32(clamping: parameters["exponent"]?.int ?? 0)))
        }

        executable.register(name: "combineWithBinaryExponent", parameterNames: ["value", "exponent"], parameterTypes: [.any, .any], returnType: .float) { parameters in
            mathFloatResult(ldexpf(parameters["value"]?.float ?? 0, Int32(clamping: parameters["exponent"]?.int ?? 0)))
        }

        executable.register(name: "binaryExponent", parameterNames: ["value"], parameterTypes: [.any], returnType: .int) { parameters in
            let value = parameters["value"]?.float ?? 0
            guard value.isFinite, !value.isZero else {
                return mathIntegerResult(0)
            }
            return mathIntegerResult(Int(ilogbf(value)))
        }

        executable.register(name: "binaryExponentAsFloat", parameterNames: ["value"], parameterTypes: [.any], returnType: .float) { parameters in
            mathFloatResult(logbf(parameters["value"]?.float ?? 0))
        }
    }

}

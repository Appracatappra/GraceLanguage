import Foundation
import Testing
@testable import GraceLanguage

@Suite("Grace MathLib", .serialized)
struct GraceMathLibTests {
    private func evaluate(_ expression: String) throws -> GraceVariable {
        let result = try GraceRuntime.shared.evaluate(script: expression)
        return try #require(result)
    }

    @Test("MathLib registers the approved API")
    func registersApprovedFunctions() throws {
        let executable = try GraceCompiler.shared.compile(program: "import MathLib;")
        let expectedNames:Set<String> = [
            "pi", "e", "positiveInfinity", "negativeInfinity", "notANumber",
            "absoluteValue", "remainder", "ieeeRemainder", "minimum", "maximum",
            "positiveDifference", "copySign", "power", "square", "cube", "squareRoot",
            "cubeRoot", "hypotenuse", "naturalExponent", "powerOfTwo",
            "naturalExponentMinusOne", "naturalLog", "baseTwoLog", "baseTenLog",
            "naturalLogPlusOne", "sine", "cosine", "tangent", "inverseSine",
            "inverseCosine", "inverseTangent", "angleFromCoordinates", "degreesToRadians",
            "radiansToDegrees", "roundUp", "roundDown", "round", "truncate",
            "roundToInteger", "isFinite", "isInfinite", "isNotANumber", "isNormal",
            "isNegative", "classifyNumber", "nextValueToward", "scaleByPowerOfTwo",
            "combineWithBinaryExponent", "binaryExponent", "binaryExponentAsFloat"
        ]

        #expect(Set(executable.functions.keys) == expectedNames)
    }

    @Test("Constants and implicit script import")
    func constantsAndImplicitImport() throws {
        #expect(abs(try evaluate("@pi()").float - .pi) < 0.000_001)
        #expect(abs(try evaluate("@e()").float - Float(M_E)) < 0.000_001)
        #expect(try evaluate("@positiveInfinity()").float == .infinity)
        #expect(try evaluate("@negativeInfinity()").float == -.infinity)
        #expect(try evaluate("@notANumber()").float.isNaN)
    }

    @Test("Arithmetic accepts loosely typed values")
    func arithmeticAndCoercion() throws {
        #expect(try evaluate("@absoluteValue(-5)").float == 5)
        #expect(try evaluate("@square('4')").float == 16)
        #expect(try evaluate("@cube('not a number')").float == 0)
        #expect(try evaluate("@remainder(7, 4)").float == 3)
        #expect(try evaluate("@ieeeRemainder(7, 4)").float == -1)
        #expect(try evaluate("@minimum(@notANumber(), 4)").float == 4)
        #expect(try evaluate("@maximum(3, @notANumber())").float == 3)
        #expect(try evaluate("@positiveDifference(8, 3)").float == 5)
        #expect(try evaluate("@copySign(2, -1)").float == -2)
    }

    @Test("Powers, roots, exponents, and logarithms")
    func powersAndLogs() throws {
        #expect(try evaluate("@power(2, 3)").float == 8)
        #expect(try evaluate("@squareRoot(81)").float == 9)
        #expect(try evaluate("@cubeRoot(-8)").float == -2)
        #expect(try evaluate("@hypotenuse(3, 4)").float == 5)
        #expect(try evaluate("@powerOfTwo(5)").float == 32)
        #expect(try evaluate("@baseTwoLog(32)").float == 5)
        #expect(try evaluate("@baseTenLog(1000)").float == 3)
        #expect(abs(try evaluate("@naturalLog(@e())").float - 1) < 0.000_001)
    }

    @Test("Trigonometry uses radians and converts angles")
    func trigonometry() throws {
        #expect(abs(try evaluate("@degreesToRadians(180)").float - .pi) < 0.000_01)
        #expect(abs(try evaluate("@radiansToDegrees(@pi())").float - 180) < 0.000_01)
        #expect(abs(try evaluate("@sine(@degreesToRadians(90))").float - 1) < 0.000_01)
        #expect(abs(try evaluate("@cosine(0)").float - 1) < 0.000_01)
        #expect(abs(try evaluate("@inverseSine(1)").float - (.pi / 2)) < 0.000_01)
        #expect(abs(try evaluate("@angleFromCoordinates(1, 0)").float - (.pi / 2)) < 0.000_01)
    }

    @Test("Rounding has predictable return types")
    func rounding() throws {
        #expect(try evaluate("@roundUp(2.1)").float == 3)
        #expect(try evaluate("@roundDown(2.9)").float == 2)
        #expect(try evaluate("@round(-2.5)").float == -3)
        #expect(try evaluate("@truncate(-2.9)").float == -2)
        #expect(try evaluate("@roundToInteger(2.5)").int == 3)
        #expect(try evaluate("@roundToInteger(@notANumber())").int == 0)
    }

    @Test("IEEE values are preserved and classified")
    func specialValuesAndClassification() throws {
        #expect(try evaluate("@squareRoot(-1)").float.isNaN)
        #expect(try evaluate("@naturalLog(0)").float == -.infinity)
        #expect(try evaluate("@isNotANumber(@notANumber())").bool)
        #expect(try evaluate("@isInfinite(@positiveInfinity())").bool)
        #expect(try evaluate("@isFinite(42)").bool)
        #expect(try evaluate("@isNormal(42)").bool)
        #expect(try evaluate("@isNegative(@copySign(0, -1))").bool)
        #expect(try evaluate("@classifyNumber(0)").string == "zero")
        #expect(try evaluate("@classifyNumber(@notANumber())").string == "notANumber")
        #expect(try evaluate("@classifyNumber(@positiveInfinity())").string == "infinite")
    }

    @Test("Floating-point representation utilities")
    func representationUtilities() throws {
        #expect(try evaluate("@nextValueToward(1, 2)").float > 1)
        #expect(try evaluate("@scaleByPowerOfTwo(3, 2)").float == 12)
        #expect(try evaluate("@combineWithBinaryExponent(0.75, 2)").float == 3)
        #expect(try evaluate("@binaryExponent(8)").int == 3)
        #expect(try evaluate("@binaryExponentAsFloat(8)").float == 3)
    }
}

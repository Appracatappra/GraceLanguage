import Foundation

/// Resolves an identifier without an explicit dereference character at runtime.
open class GraceInferredExpression: GraceExpression {
    public var parent: GraceInstruction? = nil
    public var executable: GraceExecutable? = nil
    public var name: String = ""
    public weak var coreExe: GraceExecutable? = nil

    public init() {
    }

    public func evaluate() throws -> GraceVariable? {
        if let parent, let variable = GraceRuntime.getVariable(name: name, from: parent) {
            return variable
        }

        if let function = try? GraceRuntime.getFunction(name: name, from: executable) {
            guard function.parameterNames.isEmpty else {
                throw GraceRuntimeError.missingParameter(message: "Function `\(name)` requires arguments.")
            }

            let expression = GraceFunctionExpression()
            expression.executable = executable
            expression.functionName = name
            expression.coreExe = coreExe
            return try expression.evaluate()
        }

        if (try? GraceRuntime.getEnumeration(name: name, from: executable)) != nil {
            throw GraceRuntimeError.unknownProperty(message: "Enumeration `\(name)` requires a case after `~`.")
        }

        throw GraceRuntimeError.unknownVariable(message: "Symbol `\(name)` not found.")
    }
}

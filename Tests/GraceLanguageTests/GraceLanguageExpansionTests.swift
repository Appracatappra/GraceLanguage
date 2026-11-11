import Testing
@testable import GraceLanguage

@Suite("Grace language expansions", .serialized)
struct GraceLanguageExpansionTests {
    private func run(_ program: String) throws -> GraceVariable? {
        let executable = try GraceCompiler().compile(program: program)
        return try GraceRuntime().run(executable: executable)
    }

    @Test("Unprefixed variables can be read and assigned")
    func inferredVariableAndAssignment() throws {
        let result = try run("""
        main {
            var value:int = 2;
            let value = (value + 3);
            return value;
        }
        """)

        #expect(result?.int == 5)
    }

    @Test("Unprefixed array reads work with calculated indexes")
    func inferredArrayIndex() throws {
        let result = try run("""
        main {
            var values:int array = [10, 20, 30];
            var position:int = 0;
            return values[(position + 1)];
        }
        """)

        #expect(result?.int == 20)
    }

    @Test("Long expressions use conventional precedence")
    func longExpressionPrecedence() throws {
        let result = try run("""
        main {
            var a:int = 2;
            var b:int = 3;
            var c:int = 4;
            var d:int = 5;
            return (a + b * c - d);
        }
        """)

        #expect(result?.int == 9)
    }

    @Test("Inner parentheses override precedence")
    func explicitGrouping() throws {
        let result = try run("""
        main {
            var a:int = 2;
            var b:int = 3;
            var c:int = 4;
            return ((a + b) * c);
        }
        """)

        #expect(result?.int == 20)
    }

    @Test("Calculations, comparisons, and logic combine in one expression")
    func combinedExpression() throws {
        let result = try run("""
        main {
            var a:int = 2;
            var b:int = 3;
            var c:int = 8;
            var enabled:bool = true;
            return (a + b < c and enabled or false);
        }
        """)

        #expect(result?.bool == true)
    }

    @Test("Logical operators short circuit")
    func shortCircuitEvaluation() throws {
        let result = try run("""
        main {
            return (false and ((1 / 0) > 0));
        }
        """)

        #expect(result?.bool == false)
    }

    @Test("Call syntax favors functions and bare zero-parameter functions are valid")
    func inferredFunctions() throws {
        let result = try run("""
        main {
            var left:int = answer;
            return sum(left, 1);
        }

        function answer() returns int {
            return 41;
        }

        function sum(left:int, right:int) returns int {
            return (left + right);
        }
        """)

        #expect(result?.int == 42)
    }

    @Test("Variables win general inference while call syntax still selects a function")
    func variableFunctionPrecedence() throws {
        let result = try run("""
        main {
            var value:int = 3;
            return (value + value());
        }

        function value() returns int {
            return 9;
        }
        """)

        #expect(result?.int == 12)
    }

    @Test("Enumeration case syntax favors enumerations")
    func inferredEnumeration() throws {
        let result = try run("""
        enumeration Colors {
            Red,
            Blue
        }

        main {
            var color:enumeration Colors = Colors~Red;
            return (color = Colors~Red);
        }
        """)

        #expect(result?.bool == true)
    }

    @Test("Unprefixed names resolve through executable chains at runtime")
    func chainedExecutableResolution() throws {
        let compiler = GraceCompiler()
        let base = try compiler.compile(program: """
        var sharedValue:int = 40;
        """)
        _ = try base.execute()

        let executable = try compiler.compile(program: """
        main {
            return (sharedValue + 2);
        }
        """, against: base)

        let result = try GraceRuntime().run(executable: executable)
        #expect(result?.int == 42)
    }

    @Test("Standalone unprefixed calls are valid instructions")
    func standaloneCallInstruction() throws {
        let result = try run("""
        var flag:bool = false;

        main {
            mark();
            return flag;
        }

        function mark() {
            let flag = true;
        }
        """)

        #expect(result?.bool == true)
    }

    @Test("Legacy dereferences and nested binary expressions remain compatible")
    func legacySyntax() throws {
        let result = try run("""
        main {
            var a:int = 2;
            var b:int = 3;
            var c:int = 4;
            return (($a + $b) * $c);
        }
        """)

        #expect(result?.int == 20)
    }

    @Test("Chained comparisons fail during compilation")
    func chainedComparisonCompileError() {
        #expect(throws: GraceCompilerError.self) {
            _ = try GraceCompiler().compile(program: """
            main {
                return (1 < 2 < 3);
            }
            """)
        }
    }

    @Test("Unresolved inferred names compile and fail at runtime")
    func unresolvedNameRuntimeError() throws {
        let executable = try GraceCompiler().compile(program: """
        main {
            return missingName;
        }
        """)

        #expect(throws: GraceRuntimeError.self) {
            _ = try GraceRuntime().run(executable: executable)
        }
    }
}

import XCTest
@testable import GraceLanguage
import SwiftletUtilities

final class GraceLanguageTests: XCTestCase {
    func testGrace() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:int = 5;
            var x:int = 5;
        
            return ($n + $x);
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.int == 10)
    }
    
    func testMacro() throws {
        let result = try GraceRuntime.shared.expandMacros(in: "The answer is: @intMath(40,'+',2)")
        XCTAssert(result == "The answer is: 42")
    }
    
    func testNegativeInt() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:int = 5;
        
            return @negateInt($n);
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.int == -5)
    }
    
    func testTrueNegative() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:int = -5;
        
            return $n;
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.int == -5)
    }
    
    func testNegativeFloat() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:float = 5.0;
        
            return @negateFloat($n);
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.float == -5.0)
    }
    
    func testNegativeCheat() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:int = 5;
        
            return ($n + '-1');
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.float == 4)
    }
    
    func testNot() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:bool = false;
        
            return not @flip($n);
        }
        
        function flip(n:bool) returns bool {
            return $n;
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.bool == true)
    }
    
    func testCompileSegment() throws {
        let code = """
        import StandardLib;
        
        function Card10.OnItemA() returns string {
            return "Item A";
        }
        """
        
        var exe = try GraceCompiler.shared.compile(program: code)
        
        let library = """
        function OnItemB() returns string {
            return "Item B";
        }
        """
        
        exe = try GraceCompiler.shared.compileSegment(executable: exe, programSegment: library)
        
        var result = try GraceRuntime.shared.evaluate(script: "@Card10.OnItemA()", against: exe)
        
        XCTAssert(result?.string == "Item A")
        
        result = try GraceRuntime.shared.evaluate(script: "@OnItemB()", against: exe)
        
        XCTAssert(result?.string == "Item B")
    }
    
    func testCompileChain() throws {
        let code = """
        import StandardLib;
        
        func OnItemA() returns string {
            return "Item A";
        }
        """
        
        let baseExe = try GraceCompiler.shared.compile(program: code)
        
        let library = """
        import StandardLib;
        
        func OnItemB() returns string {
            return "Item B";
        }
        
        on ItemC() returns string begin
            define first as string equals "Hello ";
            define last as string equals "World!";
        
            return ($first plus $last);
        end
        """
        
        let exe = try GraceCompiler.shared.compile(program: library, against: baseExe)
        
        var result = try GraceRuntime.shared.execute(function: "OnItemA", against: exe)
        
        XCTAssert(result?.string == "Item A")
        
        result = try GraceRuntime.shared.execute(function: "OnItemB", against: exe)
        
        XCTAssert(result?.string == "Item B")
        
        result = try GraceRuntime.shared.execute(function: "ItemC", against: exe)
        
        XCTAssert(result?.string == "Hello World!")
    }
    
    func testEmptyStringA() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:string = 'xyz';
        
            return ($n != '');
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        
        XCTAssert(result?.bool == true)
    }
    
    func testEmptyStringB() throws {
        let code = """
        import StandardLib;
        
        main {
            var n:string = '';
        
            return $n;
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        let text = result?.string
        
        XCTAssert(text == "")
    }
    
    func testComplex() throws {
        let code = """
        import StandardLib;
        import StringLib;
        
        main {
            var n:int = 1;
            var dir:string = ' ';
            var tumbler:int = 0;
            var comboA:string = '';
            var comboB:string = '';
            var comboC:string = '';
        
            if ($dir = ' ') {
                let $dir = 'L';
            } else {
                if ($dir != 'L') {
                    increment $n;
                    let $dir = 'L';
                }
            }
            call @print($dir);
        
            if ($n > 3) {
                let $n = 1;
            }
            call @print($n);
        
            decrement $tumbler;
            if ($tumbler < 0) {
                let $tumbler = 9;
            }
            call @print($tumbler);
        
            var value:string = @format("{0}{1}", [$tumbler, $dir]);
            call @print($value);
            switch $n {
                case 1 {
                    let $comboA = $value;
                }
                case 2 {
                    let $comboB = $value;
                }
                case 3 {
                    let $comboC = $value;
                }
            }
        
            var key:string = @format("{0} {1} {2}", [$comboA, $comboB, $comboC]);
            call @print($key);
            return $comboA;
        }
        """
        
        let result = try GraceRuntime.shared.run(program: code)
        let text = result?.string
        
        XCTAssert(text == "9L")
    }
}

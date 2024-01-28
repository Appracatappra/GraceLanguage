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
        
            return @testMe(-5);
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
}

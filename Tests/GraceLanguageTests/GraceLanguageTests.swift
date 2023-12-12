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
}

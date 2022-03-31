import XCTest
@testable import ImCore

final class IMIntegrationTests: XCTestCase {
    func test() throws {
        InputSourceManager.initialize()
        let sut = InputSourceManager.inputSources
        XCTAssertEqual(sut.map(\.id), [
            "com.apple.keylayout.Dvorak",
            "com.apple.inputmethod.TCIM.Shuangpin",
            "com.apple.keylayout.ABC",
            "com.apple.inputmethod.TCIM.Zhuyin", "com.apple.inputmethod.TCIM.Pinyin"])
        XCTAssertEqual(sut.map(\.name), [
            "Dvorak",
            "Shuangpin - Traditional",
            "ABC",
            "Zhuyin - Traditional",
            "Pinyin - Traditional"])
        let current = InputSource.current()
        XCTAssertEqual(current.id,
                       "com.apple.keylayout.Dvorak")
        addTeardownBlock {
            select(inputSource: current)
        }
        let abc = try XCTUnwrap(
            sut.first{$0.id == "com.apple.keylayout.ABC"}
        )
        select(inputSource: abc)
        XCTAssertEqual(InputSource.current().id,
                       "com.apple.keylayout.ABC")
        
        InputSourceManager.selectPrevious()
        
        XCTAssertEqual(InputSource.current().id,
                       "com.apple.keylayout.Dvorak")
    }
    
}

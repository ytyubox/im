import XCTest
import ImCore

final class IMIntegrationTests: XCTestCase {
    func test() throws {
        let sut = InputSourceManager()
        sut.initialize()
        XCTAssertEqual(sut.inputSources.map(\.id), [
            "com.apple.keylayout.Dvorak",
            "com.apple.inputmethod.TCIM.Shuangpin",
            "com.apple.keylayout.ABC",
            "com.apple.inputmethod.TCIM.Zhuyin", "com.apple.inputmethod.TCIM.Pinyin"])
        XCTAssertEqual(sut.inputSources.map(\.name), [
            "Dvorak",
            "Shuangpin - Traditional",
            "ABC",
            "Zhuyin - Traditional",
            "Pinyin - Traditional"])
        let current = InputSource.current()
        XCTAssertEqual(current.id,
                       "com.apple.keylayout.Dvorak")
        addTeardownBlock {
            sut.select(inputSource: current)
        }
        let abc = try XCTUnwrap(
            sut.inputSources.first{$0.id == "com.apple.keylayout.ABC"}
        )
        sut.select(inputSource: abc)
        XCTAssertEqual(InputSource.current().id,
                       "com.apple.keylayout.ABC")
        
        sut.selectPrevious()
        
        XCTAssertEqual(InputSource.current().id,
                       "com.apple.keylayout.Dvorak")
    }
    
}

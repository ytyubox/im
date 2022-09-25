import ImCore
import XCTest

final class IMIntegrationTests: XCTestCase {
    func test() throws {
        let sut = InputSourceManager()
        sut.initialize()
        XCTAssertEqual(sut.inputSources.map(\.id), [
            "com.apple.inputmethod.TCIM.Shuangpin",
            "com.apple.keylayout.ABC",
            "com.apple.keylayout.Dvorak",
        ])
        XCTAssertEqual(sut.inputSources.map(\.name), [
            "Shuangpin - Traditional",
            "ABC",
            "Dvorak",
        ])
        let current = sut.current()
        XCTAssertEqual(current.id,
                       "com.apple.keylayout.Dvorak")
        addTeardownBlock {
            sut.select(inputSource: current)
        }
        let abc = try XCTUnwrap(
            sut.inputSources.first { $0.id == "com.apple.keylayout.ABC" }
        )
        sut.select(inputSource: abc)
        XCTAssertEqual(sut.current().id,
                       "com.apple.keylayout.ABC")

        sut.selectPrevious()

        XCTAssertEqual(sut.current().id,
                       "com.apple.keylayout.Dvorak")
    }
}

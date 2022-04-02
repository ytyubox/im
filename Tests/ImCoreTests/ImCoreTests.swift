import ImCore
import XCTest

final class IMCoreTests: XCTestCase {
    func test() throws {
        let spy = Spy(
            id: nil,
            current: InputSource(id: "com.apple.keylayout.Dvorak",
                                 name: "Dvorak"),
            inputSources: [
                InputSource(id: "com.apple.keylayout.Dvorak", name: "Dvorak"),
                InputSource(id: "com.apple.inputmethod.TCIM.Shuangpin", name: "Shuangpin - Traditional"),
                InputSource(id: "com.apple.keylayout.ABC", name: "ABC"),
                InputSource(id: "com.apple.inputmethod.TCIM.Zhuyin", name: "Zhuyin - Traditional"),
                InputSource(id: "com.apple.inputmethod.TCIM.Pinyin", name: "Pinyin - Traditional"),
            ]
        )
        let sut = InputSourceManager(env: spy.makeENV())
        sut.initialize()
        XCTAssertEqual(sut.inputSources.map(\.id), [
            "com.apple.keylayout.Dvorak",
            "com.apple.inputmethod.TCIM.Shuangpin",
            "com.apple.keylayout.ABC",
            "com.apple.inputmethod.TCIM.Zhuyin", "com.apple.inputmethod.TCIM.Pinyin",
        ])
        XCTAssertEqual(sut.inputSources.map(\.name), [
            "Dvorak",
            "Shuangpin - Traditional",
            "ABC",
            "Zhuyin - Traditional",
            "Pinyin - Traditional",
        ])
        let current = sut.current()
        XCTAssertEqual(current.id,
                       "com.apple.keylayout.Dvorak")

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


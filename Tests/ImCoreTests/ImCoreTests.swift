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

private final class Spy {
    internal init(id: String? = nil, current: InputSource, inputSources: [InputSource]) {
        self.id = id
        self.current = current
        self.inputSources = inputSources
    }

    private(set) var id: String?
    private(set) var current: InputSource
    let inputSources: [InputSource]
    private var selectHistory: [InputSource] = []
    private(set) var idSetterCount = 0
    func makeENV() -> Env {
        Env(
            storage: Storage(getter: {
                self.id
            }, setter: { id in
                self.idSetterCount += 1
                self.id = id
            }),
            inputSourceMethod: InputSourceMethod(
                getInputSources: {
                    self.inputSources
                }, select: { toSelect in
                    self.selectHistory.append(toSelect)
                    self.current = toSelect
                }, current: {
                    self.current
                }
            )
        )
    }
}

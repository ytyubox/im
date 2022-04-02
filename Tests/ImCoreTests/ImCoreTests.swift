import ImCore
import XCTest

final class IMCoreTests: XCTestCase {
    func test() throws {
        let spy = Spy(
            id: nil,
            current: InputSource(id: "com.Dvorak",
                                 name: "Dvorak"),
            inputSources: eng_inputSources
        )
        let sut = InputSourceManager(env: spy.makeMemoryENV())
        sut.initialize()
        XCTAssertEqual(sut.inputSources.map(\.id), [
            "com.ABC",
            "com.Dvorak",
            "com.Pinyin",
            "com.Shuangpin",
            "com.Zhuyin",
        ])
        XCTAssertEqual(sut.inputSources.map(\.name), [
            "ABC",
            "Dvorak",
            "Pinyin - Traditional",
            "Shuangpin - Traditional",
            "Zhuyin - Traditional",
        ])
        let current = sut.current()
        XCTAssertEqual(current.id,
                       "com.Dvorak")
        XCTAssertEqual(spy.idSetterCount, 0)
        try sut.select(id: "ABC")
        XCTAssertEqual(spy.idSetterCount, 1)
        XCTAssertEqual(sut.current().id,
                       "com.ABC")
        XCTAssertEqual(spy.idHistory, ["setter com.Dvorak"])
        sut.selectPrevious()
        XCTAssertEqual(spy.idSetterCount, 2)
        XCTAssertEqual(spy.idHistory, [
            "setter com.Dvorak",
            "getter com.Dvorak",
            "setter com.ABC"])
        XCTAssertEqual(sut.current().id,
                       "com.Dvorak")
    }
    func testZH() throws {
        let spy = Spy(
            id: nil,
            current: InputSource(id: "com.Dvorak",
                                 name: "Dvorak"),
            inputSources: zh_inputSources
        )
        let sut = InputSourceManager(env: spy.makeMemoryENV())
        sut.initialize()
        XCTAssertEqual(sut.inputSources.map(\.id), [
            "com.ABC",
            "com.Dvorak",
            "com.Pinyin",
            "com.Shuangpin",
            "com.Zhuyin",
        ])
        XCTAssertEqual(sut.inputSources.map(\.name), ["ABC", "Dvorak", "拼音", "雙拼", "注音"])
        let current = sut.current()
        XCTAssertEqual(current.id,
                       "com.Dvorak")
        XCTAssertEqual(spy.idSetterCount, 0)
        try sut.select(id: "ABC")
        XCTAssertEqual(spy.idSetterCount, 1)
        XCTAssertEqual(sut.current().id,
                       "com.ABC")
        XCTAssertEqual(spy.idHistory, ["setter com.Dvorak"])
        sut.selectPrevious()
        XCTAssertEqual(spy.idSetterCount, 2)
        XCTAssertEqual(spy.idHistory, [
            "setter com.Dvorak",
            "getter com.Dvorak",
            "setter com.ABC"])
        XCTAssertEqual(sut.current().id,
                       "com.Dvorak")
    }
}

private let zh_inputSources = [
    InputSource(id: "com.Dvorak", name: "Dvorak"),
    InputSource(id: "com.ABC", name: "ABC"),
    InputSource(id: "com.Shuangpin", name: "雙拼"),
    InputSource(id: "com.Zhuyin", name: "注音"),
    InputSource(id: "com.Pinyin", name: "拼音"),
]
private let eng_inputSources = [
    InputSource(id: "com.Dvorak", name: "Dvorak"),
    InputSource(id: "com.Shuangpin", name: "Shuangpin - Traditional"),
    InputSource(id: "com.ABC", name: "ABC"),
    InputSource(id: "com.Zhuyin", name: "Zhuyin - Traditional"),
    InputSource(id: "com.Pinyin", name: "Pinyin - Traditional"),
]

import XCTest
@testable import ImCore

final class MatchTests: XCTestCase {
    func testMatch() throws {
        XCTAssertEqual(match("ShuangPin", "spin"), true)
        XCTAssertEqual(match("ShuangPin", "pin"), true)
        XCTAssertEqual(match("ShuangPin", "tpin"), false)
    }
    func testFilter() {
        let sut = [
            "Pinyin",
            "Shuangpin",
        ].filter{match($0, "spin")}
        XCTAssertEqual(sut, ["Shuangpin",])
    }
}


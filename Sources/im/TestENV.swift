import Foundation
import ImCore
#if DEBUG
var testing:Bool {
    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

private func makeSpy(_ inputSources: [InputSource]) -> Spy {
    Spy(id: nil, current: InputSource(id: "com.ABC", name: "ABC"), inputSources: inputSources)
}

private let zh = [
    InputSource(id: "com.Dvorak", name: "Dvorak"),
    InputSource(id: "com.ABC", name: "ABC"),
    InputSource(id: "com.Shuangpin", name: "雙拼"),
    InputSource(id: "com.Zhuyin", name: "注音"),
    InputSource(id: "com.Pinyin", name: "拼音"),
]
private let eng = [
    InputSource(id: "com.Dvorak", name: "Dvorak"),
    InputSource(id: "com.Shuangpin", name: "Shuangpin - Traditional"),
    InputSource(id: "com.ABC", name: "ABC"),
    InputSource(id: "com.Zhuyin", name: "Zhuyin - Traditional"),
    InputSource(id: "com.Pinyin", name: "Pinyin - Traditional"),
]
let spy = makeSpy(eng)
let env:Env = testing ? spy.makeUserDefaultsENV(list: eng) : .live
#else
let env:Env = .live
#endif

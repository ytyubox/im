import ArgumentParser
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
let env:Env = testing ? spy.makeENV() : .live
#else
let env:Env = .live
#endif
@main
struct Im: ParsableCommand {
    static var configuration = CommandConfiguration(
        version: "0.0.1"
    )
    @Flag(help: "toggle last input method by im") var toggle = false
    @Flag(help: "show list") var list = false
    @Flag(help: "show id list") var listId = false
    @Argument(help: "The ID to select") var id: String?
    mutating func run() throws {
        let obj = InputSourceManager(env: env)
        obj.initialize()
        if list {
            print(obj.inputSources.map(\.name)
                .sorted().joined(separator: "\n"))
        } else if listId {
            print(obj.inputSources.map(\.id)
                .sorted().joined(separator: "\n"))
        } else if let id = id {
            try obj.select(id: id)
        } else if toggle {
            obj.selectPrevious()
        } else {
            print(obj.current().name)
        }
    }
}

// InputSourceManager.initialize()
// if CommandLine.arguments.count == 1 {
//    let currentSource = InputSourceManager.getCurrentSource()
//    print(currentSource.id)
// } else {
//    let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue(
//        ) as NSString
//    let options = [checkOptPrompt: true]
//    let isAppTrusted = AXIsProcessTrustedWithOptions(options as CFDictionary?)
//    if(isAppTrusted == true) {
//        let dstSource = InputSourceManager.getInputSource(
//            name: CommandLine.arguments[1]
//        )
//        if CommandLine.arguments.count == 3 {
//            InputSourceManager.uSeconds = UInt32(CommandLine.arguments[2])!
//        }
//        dstSource.select()
//    } else {
//        usleep(5000000)
//    }
// }

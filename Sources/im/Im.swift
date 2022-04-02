import ArgumentParser
import Foundation
import ImCore

@main
struct Im: ParsableCommand {
    static var configuration = CommandConfiguration(
        version: "0.0.1"
    )
    @Flag(help: "toggle last input method by im") var toggle = false
    @Flag(help: "show list") var list = false
    @Flag(help: "show last id for toggle") var last = false
    @Flag(help: "show id list") var listId = false
    @Argument(help: "The ID to select") var id: String?
    mutating func run() throws {
        let manager = InputSourceManager(env: env)
        manager.initialize()
        if list {
            print(manager.inputSources.map(\.name)
                .sorted().joined(separator: "\n"))
        } else if listId {
            print(manager.inputSources.map(\.id)
                .sorted().joined(separator: "\n"))
        } else if let id = id {
            try manager.select(id: id)
        } else if toggle {
            manager.selectPrevious()
        } else if last {
            print(manager.lastID ?? "nil")
        } else {
            print(manager.current().name)
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

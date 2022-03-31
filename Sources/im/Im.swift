import Foundation
import ImCore
import ArgumentParser

@main
struct Im:ParsableCommand {
    
    @Flag(help: "show list") var list = false
    @Flag(help: "show id list") var listId = false
    @Argument(help: "The ID to select") var id: String?
    mutating func run() throws {
        let obj = InputSourceManager()
        switch list {
            case true:
                obj.initialize()
                print(obj.inputSources.map(\.name)
                        .sorted().joined(separator: "\n"))
            case false:
                print(obj.current().name)
        }
    }
}
//InputSourceManager.initialize()
//if CommandLine.arguments.count == 1 {
//    let currentSource = InputSourceManager.getCurrentSource()
//    print(currentSource.id)
//} else {
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
//}

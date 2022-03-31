import Foundation

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

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
    @Flag(help: "show list as Alfred Format") var listAlfred = false
    @Flag(help: "show im with id") var showId = false
    @Argument(help: "The ID to select") var id: String?
#if DEBUG
    @Option(help: "to inject test env") var debug: Debug?
#endif
    @Option(name: .shortAndLong, help: "Set the name to toggle")
    var setLast: String?
    mutating func run() throws {
        
        let manager:InputSourceManager
        #if DEBUG
        if let debug = debug {
            manager = InputSourceManager(env: Env(debug: debug))
        } else {
            manager = InputSourceManager()
        }
        #else
        manager = InputSourceManager()
        #endif
        manager.initialize()
        if list {
            print(manager.inputSources.map(\.name)
                    .sorted().joined(separator: "\n"))
        } else if listId {
            print(manager.inputSources.map(\.id)
                    .sorted().joined(separator: "\n"))
        } else if listAlfred {
            let alfredItems = AlfredItems(inputSources: manager.inputSources)
            let data = try! JSONEncoder().encode(alfredItems)
            print(String(data: data, encoding: .utf8)!)
            
        }
        else if let id = id {
            try manager.select(id: id)
        } else if toggle {
            manager.selectPrevious()
        } else if last {
            print(manager.lastID ?? "nil")
        } else if let setLast = setLast {
            try manager.setLastName(setLast)
            print("im --toggle will set to \(setLast)")
        }
        else {
          let current = manager.current()
          print(showId ? current.id : current.name)
        }
    }
}

// InputSourceManager.initialize()
// if CommandLine.arguments.count == 1 {
//    let currentSource = InputSourceManager.getCurrentSource()
//    print(currentSource.id)
// } else {
// }

struct Debug: Codable, ExpressibleByArgument {
    internal init(
        suitName: String,
        current: InputSource,
        inputSources: [InputSource]) {
            self.suitName = suitName
        self.current = current
        self.inputSources = inputSources
    }
    
    init?(argument: String) {
        guard let result = argument
                .data(using: .utf8)
                .flatMap({
                    data in
                    try? JSONDecoder().decode(Self.self, from: data)
                })
        else {return nil}
        self = result
    }
    let suitName: String
    let current: InputSource
    let inputSources: [InputSource]
}

extension Env {
    init(debug: Debug) {
        let ud = UserDefaults(suiteName: debug.suitName)!
        let data = try! JSONEncoder().encode(debug.current)
        if ud.data(forKey: "current") == nil {
            ud.set(data, forKey: "current")            
        }
        self.init(
            storage: Storage(getter: {
                ud.string(forKey: "id")
            }, setter: { id in
                ud.set(id, forKey: "id")
            }),
            inputSourceMethod: InputSourceMethod(
                getInputSources: {
                    debug.inputSources
                }, select: { selected in
                    let data = try! JSONEncoder().encode(selected)
                    ud.set(data, forKey: "current")
                }, current: {
                    let data = ud.data(forKey: "current")!
                    return try! JSONDecoder().decode(InputSource.self, from: data)
                }))
    }
}
import Carbon
func isAppTrusted() -> Bool {
    let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue(
        ) as NSString
    let options = [checkOptPrompt: true]
    return AXIsProcessTrustedWithOptions(options as CFDictionary?)
}

struct AlfredItems: Encodable {
    internal init(inputSources: [InputSource]) {
        self.items = inputSources.map(Item.init)
    }
    
    let items:[Item]
    struct Item: Encodable {
        internal init(inputSource: InputSource) {
            
            self.uid = inputSource.id
            self.title = inputSource.name
            self.subtitle = inputSource.id
            self.arg = inputSource.id
        }
        
        var uid: String
        var title: String
        var subtitle:String
        var arg: String
    }
}



import Foundation

public class InputSourceManager {
    public init(env: Env = .live) {
        self.env = env
    }

    let env: Env
    public private(set) var inputSources: [InputSource] = []
    var uSeconds: UInt32 = 20000

    public func initialize() {
        inputSources = env.inputSourceMethod.getInputSources().sorted{$0.id < $1.id
        }
    }

    public func getInputSource(name: String) -> [InputSource] {
        let inputSources = inputSources
        return inputSources.filter { $0.name == name }
    }
    public func getInputSource(id: String) -> [InputSource] {
        let inputSources = inputSources
        return inputSources.filter { $0.id == id }
    }
    public var lastID: String? {
        return env.storage.getter()
    }

    public func selectPrevious() {
        guard let id = env.storage.getter() else { return }
        try! select(id: id)
    }

    public func select(id: String) throws {
        if inputSources.isEmpty {
            throw ImError("found no input resource on your system, if you think this is bug, please report")
        }
        let filtered = inputSources.filter { $0.id.uppercased().contains(id.uppercased()) }
        if filtered.isEmpty {
            throw ImError("no input source found with that id:`\(id)`, maybe you did not install that?")
        }
        if filtered.count > 1 {
            throw ImError("found some input source with that id:`\(id)`, please be more specific")
        }
        select(inputSource: filtered[0])
    }

    public func select(inputSource: InputSource) {
        let currentSource = current()
        env.storage.setter(currentSource.id)
        if currentSource.id == inputSource.id {
            return
        }
        env.inputSourceMethod.select(inputSource)
    }

    public func current() -> InputSource {
        env.inputSourceMethod.current()
    }
}

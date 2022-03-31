

import Foundation

public struct Env {
    public init(storage: Storage, inputSourceMethod: InputSourceMethod) {
        self.storage = storage
        self.inputSourceMethod = inputSourceMethod
    }
    
    let storage: Storage
    let inputSourceMethod: InputSourceMethod
    public static var live: Env {fatalError()}
    
}
public struct Storage {
    public init(getter: @escaping () -> String?, setter: @escaping (String) -> Void) {
        self.getter = getter
        self.setter = setter
    }
    
    let getter: ()->String?
    let setter: (String) -> Void
}

public class InputSourceManager {
    public init(env:Env = .live) {
        self.env = env
    }
    let env: Env
    public private(set) var inputSources: [InputSource] = []
    var uSeconds: UInt32 = 20000

     public func initialize() {
         inputSources = env.inputSourceMethod.getInputSources()
    }

    public func nonCJKVSource() -> InputSource? {
        return inputSources.first(where: { !$0.isCJKV })
    }


    public func getInputSource(name: String)->InputSource{
        let inputSources = inputSources
        return inputSources.filter({$0.id == name}).first!
    }

    public func selectPrevious(){
        guard let id = UserDefaults.standard.string(forKey: "id"),
              let input = inputSources.first(where: {$0.id == id}) else {return}
        select(inputSource: input)
    }

    public func select(inputSource: InputSource) {
        let currentSource = current()
        if currentSource.id == inputSource.id {
            return
        }
        UserDefaults.standard.set(currentSource.id, forKey: "id")
        env.inputSourceMethod.select(inputSource)
        
    }
    public func current() -> InputSource {
        env.inputSourceMethod.current()
    }
}



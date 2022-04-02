import Foundation
#if DEBUG
public final class Spy {
    public init(id: String? = nil, current: InputSource, inputSources: [InputSource]) {
        self.id = id
        self.current = current
        self.inputSources = inputSources
    }
    
    public private(set) var id: String?
    public private(set) var current: InputSource
    public let inputSources: [InputSource]
    public private(set) var selectHistory: [InputSource] = []
    public private(set) var idHistory:[String] = []
    public var idSetterCount:Int {
        idHistory.filter { s in
            s.contains("setter")
        }.count
    }
    public func makeMemoryENV() -> Env {
        Env(
            storage: memoryStorage,
            inputSourceMethod: memoryMethod
        )
    }
    public func makeUserDefaultsENV(list: [InputSource]) -> Env {
        Env(
            storage: testDefaultStorage,
            inputSourceMethod: testDefaultMethod(
                current: InputSource(id: "com.ABC", name: "ABC"),
                list: list)
        )
    }
     var memoryStorage: Storage {
        Storage(getter: {
            self.idHistory.append("getter \(self.id ?? "nil")")
            return self.id
        }, setter: { id in
            self.idHistory.append("setter \(id)")
            self.id = id
        })
    }
     var memoryMethod: InputSourceMethod {
        InputSourceMethod(
            getInputSources: {
                self.inputSources
            }, select: { toSelect in
                self.selectHistory.append(toSelect)
                self.current = toSelect
            }, current: {
                self.current
            }
        )
    }
}
let defaults = UserDefaults(suiteName: "com.yu.im.test")!
public func reset() {
    defaults.set(false, forKey: "setup")
}
var testDefaultStorage: Storage {
    Storage(getter: {
        defaults.string(forKey: "test_id")
    }, setter: { id in
        defaults.set(id, forKey: "test_id")
    })
}
func testDefaultMethod(current:InputSource, list: [InputSource]) -> InputSourceMethod {
    if defaults.bool(forKey: "setup") == false {
        defaults.set(current.id, forKey: "current_id")
        defaults.set(current.name, forKey: "current_name")
        defaults.set(true, forKey: "setup")
    }
    return InputSourceMethod(
        getInputSources: {
            list
        }, select: { toSelect in
            
            defaults.set(toSelect.id, forKey: "current_id")
            defaults.set(toSelect.name, forKey: "current_name")
        }, current: {
             InputSource(id: defaults.string(forKey: "current_id")!,
                        name: defaults.string(forKey: "current_name")!)
        
            
        }
    )
}


#endif

import Foundation
public struct Env {
    public init(storage: Storage, inputSourceMethod: InputSourceMethod) {
        self.storage = storage
        self.inputSourceMethod = inputSourceMethod
    }

    let storage: Storage
    let inputSourceMethod: InputSourceMethod
    public static var live: Env {
        Env(
            storage: Storage(getter: {
                UserDefaults.standard.string(forKey: "id")
            }, setter: { id in
                UserDefaults.standard.set(id, forKey: "id")
            }),
            inputSourceMethod: InputSourceMethod.live
        )
    }
}

public struct Storage {
    public init(getter: @escaping () -> String?, setter: @escaping (String) -> Void) {
        self.getter = getter
        self.setter = setter
    }

    let getter: () -> String?
    let setter: (String) -> Void
}

struct ImError: LocalizedError {
    internal init(_ errorDescription: String) {
        self.errorDescription = errorDescription
    }

    var errorDescription: String?
}

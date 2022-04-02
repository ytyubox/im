#if DEBUG
public final class Spy {
    public init(id: String? = nil, current: InputSource, inputSources: [InputSource]) {
        self.id = id
        self.current = current
        self.inputSources = inputSources
    }

    private(set) var id: String?
    private(set) var current: InputSource
    let inputSources: [InputSource]
    public private(set) var selectHistory: [InputSource] = []
    public private(set) var idHistory:[String] = []
    public var idSetterCount:Int {
        idHistory.filter { s in
            s.contains("setter")
        }.count
    }
    public func makeENV() -> Env {
        Env(
            storage: Storage(getter: {
                self.idHistory.append("getter")
                return self.id
            }, setter: { id in
                self.idHistory.append("setter \(id)")
                self.id = id
            }),
            inputSourceMethod: InputSourceMethod(
                getInputSources: {
                    self.inputSources
                }, select: { toSelect in
                    self.selectHistory.append(toSelect)
                    self.current = toSelect
                }, current: {
                    self.current
                }
            )
        )
    }
}
#endif

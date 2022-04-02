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
    private var selectHistory: [InputSource] = []
    private(set) var idSetterCount = 0
    public func makeENV() -> Env {
        Env(
            storage: Storage(getter: {
                self.id
            }, setter: { id in
                self.idSetterCount += 1
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

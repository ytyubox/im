import Carbon
import Cocoa
public struct InputSourceMethod {
    public init(getInputSources: @escaping () -> [InputSource], select: @escaping (InputSource) -> Void, current: @escaping () -> InputSource) {
        self.getInputSources = getInputSources
        self.select = select
        self.current = current
    }

    let getInputSources: () -> [InputSource]
    let select: (InputSource) -> Void
    let current: () -> InputSource
    static var live: InputSourceMethod {
        InputSourceMethod {
            let inputSourceNSArray = TISCreateInputSourceList(nil, false)
                .takeRetainedValue() as NSArray
            let inputSourceList = inputSourceNSArray as! [TISInputSource]

            return inputSourceList.filter {
                $0.category == TISInputSource.Category.keyboardInputSource
                    && $0.isSelectable
            }
            .map { InputSource(tisInputSource: $0) }
        } select: { inputSource in
            let inputSourceNSArray = TISCreateInputSourceList(nil, false)
                .takeRetainedValue() as NSArray
            let inputSourceList = inputSourceNSArray as! [TISInputSource]

            let that = inputSourceList.first {
                $0.id == inputSource.id

            }!
            TISSelectInputSource(that)
        } current: {
            InputSource(tisInputSource: TISCopyCurrentKeyboardInputSource()
                .takeRetainedValue()
            )
        }
    }
}

extension TISInputSource {
    enum Category {
        static var keyboardInputSource: String {
            return kTISCategoryKeyboardInputSource as String
        }
    }

    private func getProperty(_ key: CFString) -> AnyObject? {
        let cfType = TISGetInputSourceProperty(self, key)
        if cfType != nil {
            return Unmanaged<AnyObject>.fromOpaque(cfType!)
                .takeUnretainedValue()
        } else {
            return nil
        }
    }

    var id: String {
        return getProperty(kTISPropertyInputSourceID) as! String
    }

    var name: String {
        return getProperty(kTISPropertyLocalizedName) as! String
    }

    var category: String {
        return getProperty(kTISPropertyInputSourceCategory) as! String
    }

    var isSelectable: Bool {
        return getProperty(kTISPropertyInputSourceIsSelectCapable) as! Bool
    }

    var sourceLanguages: [String] {
        return getProperty(kTISPropertyInputSourceLanguages) as! [String]
    }
}

extension InputSource {
    init(tisInputSource: TISInputSource) {
        id = tisInputSource.id
        name = tisInputSource.name
        sourceLanguages = tisInputSource.sourceLanguages
    }
}

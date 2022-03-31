import Foundation
import Carbon
public struct InputSource: Equatable {
    public static func current() -> InputSource {
        InputSource( tisInputSource: TISCopyCurrentKeyboardInputSource()
                .takeRetainedValue()
        )
    }
    public static func == (lhs: InputSource, rhs: InputSource) -> Bool {
        return lhs.id == rhs.id
    }

    let tisInputSource: TISInputSource

    public var id: String {
        return tisInputSource.id
    }

    public var name: String {
        return tisInputSource.name
    }

    var isCJKV: Bool {
        if let lang = tisInputSource.sourceLanguages.first {
            return lang == "ko" || lang == "ja" || lang == "vi"
            || lang.hasPrefix("zh")
        }
        return false
    }
}

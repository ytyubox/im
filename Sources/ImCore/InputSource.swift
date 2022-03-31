import Foundation
import Carbon
struct InputSource: Equatable {
    static func current() -> InputSource {
        InputSource(
            tisInputSource:
            TISCopyCurrentKeyboardInputSource().takeRetainedValue()
        )
    }
    static func == (lhs: InputSource, rhs: InputSource) -> Bool {
        return lhs.id == rhs.id
    }

    let tisInputSource: TISInputSource

    var id: String {
        return tisInputSource.id
    }

    var name: String {
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


func select(inputSource: InputSource) {
    let currentSource = InputSource.current()
    if currentSource.id == inputSource.id {
        return
    }
    UserDefaults.standard.set(currentSource.id, forKey: "id")
    TISSelectInputSource(inputSource.tisInputSource)
    if inputSource.isCJKV {
        if let nonCJKV = InputSourceManager.nonCJKVSource() {
            TISSelectInputSource(nonCJKV.tisInputSource)
            InputSourceManager.selectPrevious()
        }
    }
}

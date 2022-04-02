import Carbon
import Foundation
public struct InputSource: Equatable {
    public init(id: String, name: String, sourceLanguages: [String] = []) {
        self.id = id
        self.name = name
        self.sourceLanguages = sourceLanguages
    }

    public static func == (lhs: InputSource, rhs: InputSource) -> Bool {
        return lhs.id == rhs.id
    }

//    let tisInputSource: TISInputSource

    public var id: String
    public var name: String
    public var sourceLanguages: [String]

    var isCJKV: Bool {
        if let lang = sourceLanguages.first {
            return lang == "ko" || lang == "ja" || lang == "vi"
                || lang.hasPrefix("zh")
        }
        return false
    }
}


import Cocoa
import Carbon
import Foundation



class InputSourceManager {
    static var inputSources: [InputSource] = []
    static var uSeconds: UInt32 = 20000

    static func initialize() {
        let inputSourceNSArray = TISCreateInputSourceList(nil, false)
        .takeRetainedValue() as NSArray
        let inputSourceList = inputSourceNSArray as! [TISInputSource]

        inputSources = inputSourceList.filter(
            {
                $0.category == TISInputSource.Category.keyboardInputSource
                && $0.isSelectable
            })
            .map { InputSource(tisInputSource: $0) }
    }

    static func nonCJKVSource() -> InputSource? {
        return inputSources.first(where: { !$0.isCJKV })
    }

    static func getCurrentSource()->InputSource{
        return InputSource(
            tisInputSource:
            TISCopyCurrentKeyboardInputSource().takeRetainedValue()
        )
    }

    static func getInputSource(name: String)->InputSource{
        let inputSources = InputSourceManager.inputSources
        return inputSources.filter({$0.id == name}).first!
    }

    static func selectPrevious(){
        guard let id = UserDefaults.standard.string(forKey: "id"),
              let input = inputSources.first(where: {$0.id == id}) else {return}
        select(inputSource: input)
    }

    // from read-symbolichotkeys script of Karabiner
    // github.com/tekezo/Karabiner/blob/master/src/util/read-symbolichotkeys/read-symbolichotkeys/main.m
    
}



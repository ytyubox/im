
import Cocoa
import Carbon
import Foundation



public class InputSourceManager {
    public init() {}
    
    public private(set) var inputSources: [InputSource] = []
    var uSeconds: UInt32 = 20000

     public func initialize() {
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
        let currentSource = InputSource.current()
        if currentSource.id == inputSource.id {
            return
        }
        UserDefaults.standard.set(currentSource.id, forKey: "id")
        TISSelectInputSource(inputSource.tisInputSource)
        if inputSource.isCJKV {
            if let nonCJKV = nonCJKVSource() {
                TISSelectInputSource(nonCJKV.tisInputSource)
                selectPrevious()
            }
        }
    }

}



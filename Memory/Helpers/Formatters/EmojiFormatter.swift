//
//  Emo.swift
//  Memory
//

import Foundation

class EmojiFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let value = obj as? Double else {return nil}
        return String(value)
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
       guard let value = Double(string) else { return false }
       obj?.pointee = value as AnyObject
       return true
   }
}

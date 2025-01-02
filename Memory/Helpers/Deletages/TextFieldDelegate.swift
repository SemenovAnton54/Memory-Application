//
//  TextFieldDelegate.swift
//  Memory
//

import UIKit
@_spi(Advanced) import SwiftUIIntrospect

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var shouldReturn: (() -> Bool)?

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let shouldReturn = shouldReturn {
            return shouldReturn()
        } else {
            return true
        }
    }
}

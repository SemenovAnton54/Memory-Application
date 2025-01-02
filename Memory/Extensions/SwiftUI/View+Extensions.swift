//
//  View+Extensions.swift
//  Memory
//

import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func binding<U>(
        _ value: @autoclosure @escaping () -> U,
        _ event: @escaping (U) -> ()) -> Binding<U>
    {
        Binding(
            get: value,
            set: event
        )
    }
}

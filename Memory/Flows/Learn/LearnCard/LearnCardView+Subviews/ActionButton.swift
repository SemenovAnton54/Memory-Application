//
//  ActionButton.swift
//  Memory
//

import SwiftUI

struct ActionButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(configuration.isPressed ? Colors.itemBackgroundSecondary : Colors.itemBackground)
            .cornerRadius(10)
            .foregroundColor(Colors.actionColor)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
    }
}

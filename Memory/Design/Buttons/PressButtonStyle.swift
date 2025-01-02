//
//  PressButtonStyle.swift
//  Memory
//

import SwiftUI

struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding()
        .background(
            configuration.isPressed
            ? Color.white.opacity(0.1)
            : Color.clear
        )
    }
}

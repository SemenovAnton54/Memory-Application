//
//  PressButtonStyleWithCustomPadding.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI

struct PressButtonStyleWithCustomPadding: ButtonStyle {
    let padding: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding(padding)
        .background(
            configuration.isPressed
            ? Color.white.opacity(0.1)
            : Color.clear
        )
    }
}

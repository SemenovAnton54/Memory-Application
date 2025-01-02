//
//  LearnNewWortTypeItemView+Buttons.swift
//  Memory
//

import SwiftUI

extension LearnCardView {
    struct BottomButton: ButtonStyle {
        let color: Color

        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 45)
                .foregroundColor(.white)
                .background(color)
                .opacity(0.8)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
                .background(Rectangle().fill(.clear))
        }
    }
}

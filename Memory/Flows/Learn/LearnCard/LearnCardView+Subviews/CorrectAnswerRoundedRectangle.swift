//
//  CorrectAnswerRoundedRectangle.swift
//  Memory
//

import SwiftUI

struct CorrectAnswerRoundedRectangle: View {
    @State private var opacity: Double = 0

    let actionStyle: LearnCardState.WordCardState.ActionStyle
    let animationCompleted: () -> ()

    var body: some View {
        if case .correctAnswerAnimation(from: _) = actionStyle {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Colors.correctAnswerAnimation, lineWidth: 5)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        opacity = 1
                    } completion: {
                        animationCompleted()
                        opacity = 0
                    }
                }
        } else {
            EmptyView()
        }
    }
}

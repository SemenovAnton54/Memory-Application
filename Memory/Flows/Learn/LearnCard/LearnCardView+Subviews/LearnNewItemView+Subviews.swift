//
//  LearnCardView+Subviews.swift
//  Memory
//

import Foundation
import SwiftUI

extension LearnCardView {
    struct Header: View {
        let color: Color
        let title: String
        let editAction: () -> Void

        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(color)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)

                Spacer()

                Button("Edit") {
                    editAction()
                }
                .font(.caption)
                .foregroundColor(Colors.actionColor)
            }
        }
    }
    
    struct Bottom: View {
        let rememberAction: () -> Void
        let repeatAction: () -> Void

        var body: some View {
            HStack(spacing: 5) {
                Button(
                    action: {
                        rememberAction()
                    },
                    label: {
                        Text("Remember")
                    }
                )
                .buttonStyle(BottomButton(color: .green))

                Divider()
                    .colorInvert()
                    .frame(maxHeight: 40)

                Button(
                    action: {
                        repeatAction()
                    },
                    label: {
                        Text("Repeat")
                    }
                )
                .buttonStyle(BottomButton(color: .red))
            }
        }
    }
}

//
//  LearnRow.swift
//  Memory
//


import SwiftUI

struct LearnRow: View {
    let imageSystemName: String
    let imageColor: Color
    let title: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                Image(systemName: imageSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(width: 20)
                    .foregroundStyle(imageColor)

                VStack(alignment: .leading, spacing: 5) {
                    MainText(title)
                    SecondText(description)
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                40
            }
        }
        .buttonStyle(PressButtonStyle())
    }
}

//
//  SecondText.swift
//  Memory
//

import SwiftUI

struct SecondText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(Colors.textSecondary)
            .fontWeight(.medium)
            .font(.custom("SFMono", size: 12))
            .fontDesign(.rounded)
    }
}

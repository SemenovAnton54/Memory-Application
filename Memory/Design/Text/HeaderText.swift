//
//  HeaderText.swift
//  Memory
//

import SwiftUI

struct HeaderText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(Colors.text)
            .fontWeight(.bold)
            .font(.custom("SFMono", size: 30))
            .fontDesign(.rounded)
    }
}

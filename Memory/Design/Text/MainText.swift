//
//  MainText.swift
//  Memory
//

import SwiftUI

struct MainText: View {
    let text: String
    let fontWeight: Font.Weight

    init(_ text: String, fontWeight: Font.Weight = .medium) {
        self.text = text
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(Colors.text)
            .font(.custom("SFMono", size: 14))
            .fontWeight(fontWeight)
            .fontDesign(.rounded)
    }
}

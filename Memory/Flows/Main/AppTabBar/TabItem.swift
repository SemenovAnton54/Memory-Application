//
//  TabItem.swift
//  Memory
//

import SwiftUI

struct TabItem: View {
    let image: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: image)
            Text(text)
        }
    }
}

//
//  FolderRow.swift
//  Memory
//

import SwiftUI

struct FolderRow: View {
    let icon: String
    let name: String
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if icon.isEmpty {
                    Image(systemName: "folder")
                        .frame(maxWidth: .infinity)
                        .frame(width: 40)
                } else {
                    Text(icon)
                        .frame(maxWidth: .infinity)
                        .frame(width: 40)
                }

                VStack(alignment: .leading, spacing: 5) {
                    MainText(name)
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

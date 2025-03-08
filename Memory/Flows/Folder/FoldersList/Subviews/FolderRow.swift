//
//  FolderRow.swift
//  Memory
//

import SwiftUI

struct FolderRow: View {
    let id: Int
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
                        .accessibilityIdentifier(FoldersListAccessibilityIdentifier.folderCellIcon(id: id))
                } else {
                    Text(icon)
                        .frame(maxWidth: .infinity)
                        .frame(width: 40)
                        .accessibilityIdentifier(FoldersListAccessibilityIdentifier.folderCellIcon(id: id))
                }

                VStack(alignment: .leading, spacing: 5) {
                    MainText(name)
                        .accessibilityIdentifier(FoldersListAccessibilityIdentifier.folderCellTitle(id: id))
                    SecondText(description)
                        .accessibilityIdentifier(FoldersListAccessibilityIdentifier.folderCellDescription(id: id))
                }
                Spacer()
            }
            .contentShape(Rectangle())
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                40
            }
        }
        .buttonStyle(PressButtonStyle())
        .accessibilityIdentifier(FoldersListAccessibilityIdentifier.folderCell(id: id))
    }
}

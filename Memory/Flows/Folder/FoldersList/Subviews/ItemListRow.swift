//
//  ItemListRow.swift
//  Memory
//

import SwiftUI

struct ItemListRow: View {
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
                        .accessibilityIdentifier(EditItemListAccessibilityIdentifier.itemListCellIcon(id: id))
                } else {
                    Text(icon)
                        .frame(maxWidth: .infinity)
                        .frame(width: 40)
                        .accessibilityIdentifier(EditItemListAccessibilityIdentifier.itemListCellIcon(id: id))
                }

                VStack(alignment: .leading, spacing: 5) {
                    MainText(name)
                        .accessibilityIdentifier(EditItemListAccessibilityIdentifier.itemListCellTitle(id: id))
                    SecondText(description)
                        .accessibilityIdentifier(EditItemListAccessibilityIdentifier.itemListCellDescription(id: id))
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

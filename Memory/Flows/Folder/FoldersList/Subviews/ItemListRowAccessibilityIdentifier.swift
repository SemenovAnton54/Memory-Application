//
//  ItemListRowAccessibilityIdentifier.swift
//  Memory
//
//  Created by Anton Semenov on 09.03.2025.
//

public enum EditItemListAccessibilityIdentifier {
    public static func itemListCellTitle(id: Int) -> String {
        "item_list_cell_title_\(id)"
    }

    public static func itemListCellDescription(id: Int) -> String {
        "item_list_cell_description_\(id)"
    }

    public static func itemListCellIcon(id: Int) -> String {
        "item_list_cell_icon_\(id)"
    }
}

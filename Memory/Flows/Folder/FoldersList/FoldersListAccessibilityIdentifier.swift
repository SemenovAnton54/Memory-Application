//
//  FoldersListAccessibilityIdentifier.swift
//  Memory
//
//  Created by Anton Semenov on 07.03.2025.
//

public enum FoldersListAccessibilityIdentifier {
    public static let folderList = "folderList"
    public static let newFolderButton = "newFolderButton"
    public static func folderCell(id: Int) -> String {
        "folder_cell_\(id)"
    }

    public static func folderCellTitle(id: Int) -> String {
        "folder_cell_title_\(id)"
    }

    public static func folderCellDescription(id: Int) -> String {
        "folder_cell_description_\(id)"
    }

    public static func folderCellIcon(id: Int) -> String {
        "folder_cell_icon_\(id)"
    }
}

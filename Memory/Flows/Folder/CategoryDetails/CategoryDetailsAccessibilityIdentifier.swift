//
//  CategoryDetailsAccessibilityIdentifier.swift
//  Memory
//
//  Created by Anton Semenov on 07.03.2025.
//

public enum CategoryDetailsAccessibilityIdentifier {
    public static let options = "categoryDetailsOptions"
    public static let editButton = "categoryDetailsEditButton"
    public static let cancelButton = "categoryDetailsCancelButton"
    public static let deleteButton = "categoryDetailsDeleteButton"
    public static let collectionView = "categoryDetailsCollectionView"
    public static let nameTitle = "categoryDetailsNameTitle"
    public static let nameValue = "categoryDetailsNameValue"
    public static let iconTitle = "categoryDetailsIconTitle"
    public static let iconValue = "categoryDetailsIconValue"
    public static let descriptionTitle = "categoryDetailsDescriptionTitle"
    public static let descriptionValue = "categoryDetailsDescriptionValue"
    public static let addCategoryButton = "categoryDetailsAddCategoryButton"

    public static func categoryCell(id: Int) -> String {
        "category_cell_\(id)"
    }
}

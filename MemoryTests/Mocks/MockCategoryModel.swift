//
//  MockCategoryModel.swift
//  Memory
//
//  Created by Anton Semenov on 06.01.2025.
//

@testable import Memory

enum MockCategoryModel {
    static func mockCategory(
        id: Int = 1,
        folderId: Int = 1,
        name: String = "Name",
        desc: String? = "Description",
        icon: String? = "🥹",
        image: ImageType? = .systemName("Mock Image")
    ) -> CategoryModel {
        CategoryModel(
            id: id,
            folderId: folderId,
            name: name,
            desc: desc,
            icon: icon,
            image: image
        )
    }

    static func mockNewCategoryModel(
        folderId: Int? = 1,
        name: String = "Mock Name",
        desc: String? = "Mock Description",
        icon: String = "😇",
        image: ImageType? = .systemName("Mock image")
    ) -> NewCategoryModel {
        NewCategoryModel(
            folderId: folderId,
            name: name,
            desc: desc,
            icon: icon,
            image: image
        )!
    }

    static func mockUpdateCategoryModel(
        id: Int = 1,
        folderId: Int? = 1,
        name: String = "Mock Name",
        desc: String? = "Mock Description",
        icon: String = "😇",
        image: ImageType? = .systemName("Mock image")
    ) -> UpdateCategoryModel {
        UpdateCategoryModel(
            id: id,
            folderId: folderId,
            name: name,
            desc: desc,
            icon: icon,
            image: image
        )!
    }
}

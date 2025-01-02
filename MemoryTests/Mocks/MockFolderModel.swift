//
//  MockFolderModel.swift
//  Memory
//

@testable import Memory

enum MockFolderModel {
    static func mockFolder(
        id: Int = 1,
        name: String = "Name",
        desc: String? = "Description",
        isFavorite: Bool = false,
        icon: String? = "🥹",
        image: ImageObject? = .systemName("Mock Image")
    ) -> FolderModel {
        FolderModel(
            id: id,
            name: name,
            desc: desc,
            isFavorite: isFavorite,
            icon: icon,
            image: image
        )
    }

    static func mockNewFolderModel(
        name: String = "Mock Name",
        desc: String? = "Mock Description",
        isFavorite: Bool = false,
        icon: String = "😇",
        image: ImageObject? = .systemName("Mock image")
    ) -> NewFolderModel {
        NewFolderModel(
            name: name,
            desc: desc,
            isFavorite: isFavorite,
            icon: icon,
            image: image
        )!
    }

    static func mockUpdateFolderModel(
        id: Int = 1,
        name: String = "Mock Name",
        desc: String? = "Mock Description",
        isFavorite: Bool = false,
        icon: String = "😇",
        image: ImageObject? = .systemName("Mock image")
    ) -> UpdateFolderModel {
        UpdateFolderModel(
            id: id,
            name: name,
            desc: desc,
            isFavorite: isFavorite,
            icon: icon,
            image: image
        )!
    }
}


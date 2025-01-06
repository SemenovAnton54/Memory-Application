//
//  MockRememberItemModel.swift
//  Memory
//
//  Created by Anton Semenov on 06.01.2025.
//

import Foundation

@testable import Memory

enum MockRememberItemModel {
    static func mockRememberItemModel(
        id: Int = 1,
        categoriesIds: [Int] = [1],
        type: RememberCardItemType = .word,
        repeatLevel: RepeatLevel = .learning,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastIncreasedLevelAt: Date = Date(),
        word: WordModel? = WordModel(
            id: 1,
            word: "Word",
            transcription: "woorrrdd",
            translation: "Слово",
            examples: [
                .init(example: "Example one", translation: "Пример первый"),
                .init(example: "Example two", translation: "Пример второй"),
            ],
            images: [.systemName("test"), .systemName("text2")]
        )
    ) -> RememberCardItemModel {
        RememberCardItemModel(
            id: id,
            categoryIds: categoriesIds,
            type: type,
            repeatLevel: repeatLevel,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastIncreasedLevelAt: lastIncreasedLevelAt,
            word: word
        )
    }

//    static func mockNewCategoryModel(
//        folderId: Int? = 1,
//        name: String = "Mock Name",
//        desc: String? = "Mock Description",
//        icon: String = "😇",
//        image: ImageType? = .systemName("Mock image")
//    ) -> NewCategoryModel {
//        NewCategoryModel(
//            folderId: folderId,
//            name: name,
//            desc: desc,
//            icon: icon,
//            image: image
//        )!
//    }
//
//    static func mockUpdateCategoryModel(
//        id: Int = 1,
//        folderId: Int? = 1,
//        name: String = "Mock Name",
//        desc: String? = "Mock Description",
//        icon: String = "😇",
//        image: ImageType? = .systemName("Mock image")
//    ) -> UpdateCategoryModel {
//        UpdateCategoryModel(
//            id: id,
//            folderId: folderId,
//            name: name,
//            desc: desc,
//            icon: icon,
//            image: image
//        )!
//    }
}

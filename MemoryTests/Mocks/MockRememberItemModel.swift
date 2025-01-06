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

    static func mockNewRememberItemModel(
        categoriesIds: [Int] = [1],
        type: RememberCardItemType = .word,
        repeatLevel: RepeatLevel = .learning,
        createdAt: Date = Date(),
        word: NewWordModel? = NewWordModel(
            word: "Word",
            translation: "Слово",
            transcription: "woorrrdd",
            images: [.systemName("test"), .systemName("text2")],
            examples: [
                .init(example: "Example one", translation: "Пример первый"),
                .init(example: "Example two", translation: "Пример второй"),
            ]
        )
    ) -> NewRememberItemModel {
        NewRememberItemModel(
            categoryIds: [],
            type: type,
            repeatLevel: repeatLevel,
            createdAt: createdAt,
            word: word
        )
    }

    static func mockUpdateRememberItemModel(
        id: Int = 1,
        categoriesIds: [Int] = [1],
        type: RememberCardItemType = .word,
        repeatLevel: RepeatLevel = .learning,
        createdAt: Date = Date(),
        word: UpdateWordModel? = UpdateWordModel(
            id: 1,
            word: "Word",
            translation: "Слово",
            transcription: "woorrrdd",
            images: [.systemName("test"), .systemName("text2")],
            examples: [
                .init(example: "Example one", translation: "Пример первый"),
                .init(example: "Example two", translation: "Пример второй"),
            ]
        )
    ) -> UpdateRememberItemModel {
        UpdateRememberItemModel(
            id: id,
            categoryIds: [],
            type: type,
            word: word
        )
    }
}

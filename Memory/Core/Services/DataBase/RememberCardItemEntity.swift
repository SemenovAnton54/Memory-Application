//
//  RememberCardItemEntity.swift
//  Memory
//

import Foundation
import SwiftData

@Model
final class RememberCardItemEntity {
    @Attribute(.unique) var id: Int

    var categoryIds: [Int] = []
    var type: RememberCardItemType
    var repeatLevel: RepeatLevel
    var createdAt: Date
    var updatedAt: Date
    var lastIncreasedLevelAt: Date?
    var repeatsCount: Int = 0
    var word: WordEntity?

    init(
        id: Int,
        categoryIds: [Int],
        type: RememberCardItemType,
        repeatLevel: RepeatLevel,
        createdAt: Date = Date(),
        updatedAt: Date? = nil,
        lastIncreasedLevelAt: Date? = nil,
        word: WordEntity?
    ) {
        self.id = id
        self.categoryIds = categoryIds
        self.type = type
        self.repeatLevel = repeatLevel
        self.createdAt = createdAt
        self.updatedAt = updatedAt ?? createdAt
        self.lastIncreasedLevelAt = lastIncreasedLevelAt

        self.word = word
    }

    init(model: RememberCardItemModel) {
        id = model.id
        categoryIds = model.categoriesIds
        type = model.type
        repeatLevel = model.repeatLevel
        createdAt = model.createdAt
        updatedAt = model.updatedAt ?? model.createdAt
        lastIncreasedLevelAt = model.lastIncreasedLevelAt

        word = model.word.flatMap { WordEntity(model: $0) }
    }

    func update(with model: UpdateRememberItemModel) {
        id = model.id
        categoryIds = model.categoryIds
        type = model.type
        updatedAt = Date()

        if let word = self.word, let updatedWord = model.word {
            word.update(with: updatedWord)
        } else {
            word = model.word.flatMap {
                WordEntity(
                    id: $0.id,
                    word: $0.word,
                    translation: $0.translation,
                    transcription: $0.transcription,
                    images: $0.images,
                    examples: $0.examples
                )
            }
        }
    }
}

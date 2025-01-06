//
//  RememberCardItemModel.swift
//  Memory
//

import Foundation

struct RememberCardItemModel {
    let id: Int

    let categoriesIds: [Int]
    let type: RememberCardItemType
    let repeatLevel: RepeatLevel
    let createdAt: Date
    let updatedAt: Date?
    let lastIncreasedLevelAt: Date?

    let word: WordModel?

    init(from entity: RememberCardItemEntity) {
        id = entity.id
        categoriesIds = entity.categoryIds
        type = entity.type
        repeatLevel = entity.repeatLevel
        createdAt = entity.createdAt
        updatedAt = entity.updatedAt
        lastIncreasedLevelAt = entity.lastIncreasedLevelAt

        if let word = entity.word {
            self.word = WordModel(from: word)
        } else {
            word = nil
        }
    }

    init(
        id: Int,
        categoryIds: [Int],
        type: RememberCardItemType,
        repeatLevel: RepeatLevel,
        createdAt: Date,
        updatedAt: Date?,
        lastIncreasedLevelAt: Date?,
        word: WordModel?
    ) {
        self.id = id
        self.categoriesIds = categoryIds
        self.type = type
        self.repeatLevel = repeatLevel
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastIncreasedLevelAt = lastIncreasedLevelAt
        self.word = word
    }
}

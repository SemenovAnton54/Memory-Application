//
//  RememberCardItemModel.swift
//  Memory
//

import Foundation

struct RememberCardItemModel {
    let id: Int

    let categoryIds: [Int]
    let type: RememberCardItemType
    let repeatLevel: RepeatLevel
    let createdAt: Date
    let updatedAt: Date?
    let lastIncreasedLevelAt: Date?

    let word: WordModel?

    init(from entity: RememberCardItemEntity) {
        id = entity.id
        categoryIds = entity.categoryIds
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
}

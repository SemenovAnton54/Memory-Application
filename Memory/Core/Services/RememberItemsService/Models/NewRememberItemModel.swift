//
//  NewRememberItemModel.swift
//  Memory
//

import Foundation

struct NewRememberItemModel {
    let categoryIds: [Int]
    let type: RememberCardItemType
    let repeatLevel: RepeatLevel
    let createdAt: Date
    let updatedAt: Date
    let lastIncreasedLevelAt: Date?

    let word: NewWordModel?

    init(
        categoryIds: [Int],
        type: RememberCardItemType,
        repeatLevel: RepeatLevel,
        createdAt: Date = Date(),
        word: NewWordModel?
    ) {
        self.categoryIds = categoryIds
        self.type = type
        self.repeatLevel = repeatLevel
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.lastIncreasedLevelAt = nil
        self.word = word
    }
}

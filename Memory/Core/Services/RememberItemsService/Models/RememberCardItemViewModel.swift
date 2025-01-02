//
//  RememberCardItemViewModel.swift
//  Memory
//

import Foundation

struct RememberCardItemViewModel: Identifiable {
    let id: Int
    let categoryIds: [Int]
    let type: RememberCardItemType
    let repeatLevel: RepeatLevel
    let createdAt: Date
    let updatedAt: Date?
    let levelChangedAt: Date?

    let word: WordViewModel?

    init(from model: RememberCardItemModel) {
        id = model.id
        categoryIds = model.categoryIds
        type = model.type
        repeatLevel = model.repeatLevel
        createdAt = model.createdAt
        updatedAt = model.updatedAt
        levelChangedAt = model.lastIncreasedLevelAt

        if let wordModel = model.word {
            word = WordViewModel(from: wordModel)
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
        levelChangedAt: Date?,
        word: WordModel?
    ) {
        self.id = id
        self.categoryIds = categoryIds
        self.type = type
        self.repeatLevel = repeatLevel
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.levelChangedAt = levelChangedAt
        self.word = word.flatMap { WordViewModel(from: $0) }
    }
}

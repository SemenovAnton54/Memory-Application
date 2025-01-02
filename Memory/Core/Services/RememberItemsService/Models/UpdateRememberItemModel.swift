//
//  UpdateRememberItemModel.swift
//  Memory
//

import Foundation

struct UpdateRememberItemModel {
    let id: Int

    var categoryIds: [Int]
    var type: RememberCardItemType

    var word: UpdateWordModel?

    init(
        id: Int,
        categoryIds: [Int],
        type: RememberCardItemType,
        word: UpdateWordModel?
    ) {
        self.id = id
        self.categoryIds = categoryIds
        self.type = type
        self.word = word
    }
}

//
//  SelectFolderLearningModeRouterMock.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

@testable import Memory

final class SelectFolderLearningModeRouterMock: SelectFolderLearningModeRouterProtocol {
    var didLearnNewCardsWithFolderId: Int?
    var didReviewCardsWithFolderId: Int?

    func learnNewCards(folderId: Int) {
        didLearnNewCardsWithFolderId = folderId
    }

    func reviewCards(folderId: Int) {
        didReviewCardsWithFolderId = folderId
    }
}

//
//  LearnMainRouterMock.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

@testable import Memory

class LearnMainRouterMock: LearnMainRouterProtocol {
    var didSelectLearnModeWithId: Int?
    var didAllFolders: Bool = false
    var didLearnFolderWithId: Int?
    var didReviewFolderWithId: Int?

    func selectLearnMode(for folder: Int) {
        didSelectLearnModeWithId = folder
    }

    func allFolders() {
        didAllFolders = true
    }

    func learnFolder(id: Int) {
        didLearnFolderWithId = id
    }

    func reviewFolder(id: Int) {
        didReviewFolderWithId = id
    }
}

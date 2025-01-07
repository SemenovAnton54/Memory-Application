//
//  LearnFoldersListRouterMock.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

@testable import Memory

class LearnFoldersListRouterMock: LearnFoldersListRouterProtocol {
    var didLearnFolderWithId: Int?

    func learnFolder(id: Int) {
        didLearnFolderWithId = id
    }
}

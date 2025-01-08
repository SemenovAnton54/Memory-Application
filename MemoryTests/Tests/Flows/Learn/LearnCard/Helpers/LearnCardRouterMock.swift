//
//  LearnCardRouterMock.swift
//  Memory
//
//  Created by Anton Semenov on 08.01.2025.
//

@testable import Memory

class LearnCardRouterMock: LearnCardRouterProtocol {
    var didEditRememberItemWithId: Int?

    func editRememberItem(id: Int) {
        didEditRememberItemWithId = id
    }
}


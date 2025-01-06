//
//  FoldersListRouterMock.swift
//  Memory
//

@testable import Memory

class FoldersListRouterMock: FoldersListRouterProtocol {
    var didOpenFolderWithId: Int?
    var didNewFolder: Bool = false

    func openFolder(id: Int) {
        didOpenFolderWithId = id
    }

    func newFolder() {
        didNewFolder = true
    }
}

//
//  FolderDetailsRouterMock.swift
//  Memory
//

@testable import Memory

class FolderDetailsRouterMock: FolderDetailsRouterProtocol {
    enum TriggerWithInt: Equatable {
        case triggered(Int)
        case notTriggered
    }

    var didClose: Bool = false
    var didNewCategoryWithFolderId: TriggerWithInt?
    var didCategoryDetailsWithId: TriggerWithInt?
    var didEditFolderWithId: TriggerWithInt?

    func close() {
        didClose = true
    }

    func editFolder(id: Int) {
        didEditFolderWithId = .triggered(id)
    }

    func newCategory(for folder: Int) {
        didNewCategoryWithFolderId = .triggered(folder)
    }

    func categoryDetails(id: Int) {
        didCategoryDetailsWithId = .triggered(id)
    }
}

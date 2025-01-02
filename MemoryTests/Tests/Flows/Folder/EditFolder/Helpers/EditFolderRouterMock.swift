//
//  EditFolderRouterMock.swift
//  Memory
//

@testable import Memory

class EditFolderRouterMock: EditFolderRouterProtocol {
    var didClose: Bool = false

    func close() {
        didClose = true
    }
}

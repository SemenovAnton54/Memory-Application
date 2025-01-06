//
//  EditCategoryRouterMock.swift
//  Memory
//

@testable import Memory

class EditCategoryRouterMock: EditCategoryRouterProtocol {
    var didClose: Bool = false

    func close() {
        didClose = true
    }
}

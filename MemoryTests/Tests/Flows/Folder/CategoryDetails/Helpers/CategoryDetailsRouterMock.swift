//
//  CategoryDetailsRouterMock.swift
//  Memory
//

@testable import Memory

class CategoryDetailsRouterMock: CategoryDetailsRouterProtocol {
    var didClose: Bool = false
    var didEditCategoryWithId: Int?
    var didEditRememberItemWithId: Int?
    var didNewRememberItemWithCategoryId: Int?

    func close() {
        didClose = true
    }

    func editCategory(id: Int) {
        didEditCategoryWithId = id
    }

    func newRememberItem(for category: Int) {
        didNewRememberItemWithCategoryId = category
    }

    func editRememberItem(id: Int) {
        didEditRememberItemWithId = id
    }
}

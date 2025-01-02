//
//  CategoryDetailsRouterProtocol.swift
//  Memory
//

protocol CategoryDetailsRouterProtocol {
    func close()
    func editCategory(id: Int)
    func newRememberItem(for category: Int)
    func editRememberItem(id: Int)
}

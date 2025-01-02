//
//  FolderDetailsRouterProtocol.swift
//  Memory
//

protocol FolderDetailsRouterProtocol {
    func close()
    func editFolder(id: Int)
    func newCategory(for folder: Int)
    func categoryDetails(id: Int)
}

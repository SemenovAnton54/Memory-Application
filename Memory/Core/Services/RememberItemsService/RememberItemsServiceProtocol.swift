//
//  RememberItemsServiceProtocol.swift
//  Memory
//

import Foundation

protocol RememberItemsServiceProtocol {
    func fetchItem(id: Int) async throws -> RememberCardItemModel

    func fetchItems(for category: Int) async throws -> [RememberCardItemModel]
    func fetchItems(for categories: [Int]) async throws -> [RememberCardItemModel]

    func createItem(newItem: NewRememberItemModel) async throws -> RememberCardItemModel
    func updateItem(item: UpdateRememberItemModel) async throws -> RememberCardItemModel

    func increaseRepeatLevel(id: Int) async throws -> RememberCardItemModel
    func decreaseRepeatLevel(id: Int) async throws -> RememberCardItemModel

    func remove(id: Int) async throws -> RememberCardItemModel
}

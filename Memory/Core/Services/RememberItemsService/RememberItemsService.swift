//
//  RememberItemsService.swift
//  Memory
//

import Foundation
import SwiftData

@ModelActor
actor RememberItemsService: RememberItemsServiceProtocol {
    enum RememberItemsServiceError: Error {
        case rememberItemNotFound
        case emptyWord
    }

    private var context: ModelContext { modelExecutor.modelContext }

    func fetchItems(for category: Int) async throws -> [RememberCardItemModel] {
        let descriptor = FetchDescriptor<RememberCardItemEntity>()
        let categories = try context.fetch(descriptor).filter {
            $0.categoryIds.contains(category)
        }

        return categories.map(RememberCardItemModel.init)
    }

    func fetchItems(for categories: [Int]) async throws -> [RememberCardItemModel] {
        let categoriesIds = Set(categories)

        let descriptor = FetchDescriptor<RememberCardItemEntity>()
        let categories = try context.fetch(descriptor).filter {
            !categoriesIds.intersection($0.categoryIds).isEmpty
        }

        return categories.map(RememberCardItemModel.init)
    }

    func createItem(newItem: NewRememberItemModel) async throws -> RememberCardItemModel {
        let wordMaxId = try await wordMaxId()
        let wordEntity = newItem.word.flatMap { WordEntity(id: wordMaxId + 1, model: $0) }

        let object = RememberCardItemEntity(
            id: try await maxId() + 1,
            categoryIds: newItem.categoryIds,
            type: newItem.type,
            repeatLevel: newItem.repeatLevel,
            createdAt: newItem.createdAt,
            updatedAt: newItem.updatedAt,
            lastIncreasedLevelAt: newItem.lastIncreasedLevelAt,
            word: wordEntity
        )

        try perform { context in
            context.insert(object)
        }

        return RememberCardItemModel(from: object)
    }

    func fetchItem(id: Int) async throws -> RememberCardItemModel {
        let entity = try loadRememberItemEntity(id: id)

        return RememberCardItemModel(from: entity)
    }

    func updateItem(item: UpdateRememberItemModel) async throws -> RememberCardItemModel {
        let entity = try loadRememberItemEntity(id: item.id)

        entity.update(with: item)

        try perform { context in
            context.insert(entity)
        }

        return RememberCardItemModel(from: entity)

    }

    func remove(id: Int) async throws -> RememberCardItemModel {
        guard let entity = try? loadRememberItemEntity(id: id) else {
            throw RememberItemsServiceError.rememberItemNotFound
        }

        let model = RememberCardItemModel(from: entity)

        try perform { context in
            context.delete(entity)
        }

        return model
    }

    func increaseRepeatLevel(id: Int) async throws -> RememberCardItemModel {
        let entity = try loadRememberItemEntity(id: id)

        try perform { _ in
            entity.repeatLevel = entity.repeatLevel.next()
            entity.lastIncreasedLevelAt = Date()
        }

        return RememberCardItemModel(from: entity)
    }

    func decreaseRepeatLevel(id: Int) async throws -> RememberCardItemModel {
        let entity = try loadRememberItemEntity(id: id)
        let previousLevel = entity.repeatLevel.previous()

        if previousLevel == .newItem {
            try perform { _ in
                entity.repeatLevel = .learning
            }
        }

        guard previousLevel > .learning else {
            return RememberCardItemModel(from: entity)
        }

        try perform { _ in
            entity.repeatLevel = previousLevel
        }

        return RememberCardItemModel(from: entity)
    }

    private func perform(_ block: (ModelContext) -> ()) throws {
        block(context)
        try context.save()
    }

    private func maxId() async throws -> Int {
        let categories = try context.fetch(FetchDescriptor<RememberCardItemEntity>())

        return categories.map(\.id).max() ?? 0
    }

    private func wordMaxId() async throws -> Int {
        let categories = try context.fetch(FetchDescriptor<WordEntity>())

        return categories.map(\.id).max() ?? 0
    }

    private func loadRememberItemEntity(id: Int) throws -> RememberCardItemEntity {
        let predicate = #Predicate<RememberCardItemEntity> { object in
            object.id == id
        }

        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        let object = try context.fetch(descriptor)

        guard let first = object.first else {
            throw RememberItemsServiceError.rememberItemNotFound
        }

        return first
    }
}

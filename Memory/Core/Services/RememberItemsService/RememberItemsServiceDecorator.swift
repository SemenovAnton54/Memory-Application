//
//  RememberItemsServiceDecorator.swift
//  Memory
//

final class RememberItemsServiceDecorator: RememberItemsServiceProtocol {
    struct Dependencies {
        let rememberItemsService: RememberItemsServiceProtocol
        let appEventsClientProtocol: AppEventsClientProtocol
    }

    let rememberItemsService: RememberItemsServiceProtocol
    let appEventsClientProtocol: AppEventsClientProtocol

    init(dependencies: Dependencies) {
        rememberItemsService = dependencies.rememberItemsService
        appEventsClientProtocol = dependencies.appEventsClientProtocol
    }

    func fetchItem(id: Int) async throws -> RememberCardItemModel {
        try await rememberItemsService.fetchItem(id: id)
    }
    
    func fetchItems(for category: Int) async throws -> [RememberCardItemModel] {
        try await rememberItemsService.fetchItems(for: category)
    }
    
    func fetchItems(for categories: [Int]) async throws -> [RememberCardItemModel] {
        try await rememberItemsService.fetchItems(for: categories)
    }
    
    func createItem(newItem: NewRememberItemModel) async throws -> RememberCardItemModel {
        defer {
            appEventsClientProtocol.emit(RememberItemEvent.rememberItemCreated)
        }

        return try await rememberItemsService.createItem(newItem: newItem)
    }
    
    func updateItem(item: UpdateRememberItemModel) async throws -> RememberCardItemModel {
        let item = try await rememberItemsService.updateItem(item: item)

        appEventsClientProtocol.emit(RememberItemEvent.rememberItemUpdated(id: item.id))

        return item
    }
    
    func increaseRepeatLevel(id: Int) async throws -> RememberCardItemModel {
        let item = try await rememberItemsService.increaseRepeatLevel(id: id)

        appEventsClientProtocol.emit(RememberItemEvent.rememberItemUpdated(id: item.id))

        return item
    }
    
    func decreaseRepeatLevel(id: Int) async throws -> RememberCardItemModel {
        let item = try await rememberItemsService.decreaseRepeatLevel(id: id)

        appEventsClientProtocol.emit(RememberItemEvent.rememberItemUpdated(id: item.id))

        return item
    }
    
    func remove(id: Int) async throws -> RememberCardItemModel {
        let item = try await rememberItemsService.remove(id: id)

        appEventsClientProtocol.emit(RememberItemEvent.rememberItemDeleted(id: item.id))

        return item
    }
}

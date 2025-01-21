//
//  FoldersService.swift
//  Memory
//

import Foundation
import SwiftData

@ModelActor
actor FoldersService: FoldersServiceProtocol {
    enum FoldersServiceError: Error {
        case folderNotExist
    }

    private var context: ModelContext { modelExecutor.modelContext }

    func fetchFolders(filters: FolderFilters?) async throws -> [FolderModel] {
        let filter: (FolderEntity) -> Bool = { object in
            guard let filters else {
                return true
            }

            if let isFavorite = filters.isFavorite, object.isFavorite != isFavorite {
                return false
            }

            return true
        }

        let folders = try context.fetch(FetchDescriptor<FolderEntity>()).filter {
            filter($0)
        }

        return folders.map(FolderModel.init)
    }

    func createFolder(newFolder: NewFolderModel) async throws -> FolderModel {
        let object = FolderEntity(
            id: try await maxId() + 1,
            name: newFolder.name,
            desc: newFolder.desc,
            isFavorite: newFolder.isFavorite,
            icon: newFolder.icon,
            image: newFolder.image
        )

        context.insert(object)
        try context.save()

        return FolderModel(from: object)
    }

    func fetchFolder(id: Int) async throws -> FolderModel {
        guard let entity = try? fetchFolderEntity(id: id) else {
            throw FoldersServiceError.folderNotExist
        }

        return FolderModel(from: entity)
    }

    func updateFolder(folder: UpdateFolderModel) async throws -> FolderModel {
        guard let entity = try? fetchFolderEntity(id: folder.id) else {
            throw FoldersServiceError.folderNotExist
        }

        entity.update(with: folder)

        context.insert(entity)
        try context.save()

        return FolderModel(from: entity)

    }

    func remove(id: Int) async throws -> FolderModel {
        guard let entity = try? fetchFolderEntity(id: id) else {
            throw FoldersServiceError.folderNotExist
        }

        let model = FolderModel(from: entity)
        context.delete(entity)
        try context.save()
        
        return model
    }

    private func maxId() async throws -> Int {
        (try await fetchFolders().map(\.id).max() ?? 0)
    }

    private func fetchFolderEntity(id: Int) throws -> FolderEntity {
        let predicate = #Predicate<FolderEntity> { object in
            object.id == id
        }

        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        let object = try context.fetch(descriptor)

        guard let first = object.first else {
            throw FoldersServiceError.folderNotExist
        }

        return first
    }
}

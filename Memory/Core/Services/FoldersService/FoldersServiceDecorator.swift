//
//  FoldersServiceDecorator.swift
//  Memory
//

class FoldersServiceDecorator: FoldersServiceProtocol {
    struct Dependencies {
        let foldersService: FoldersServiceProtocol
        let appEventsClient: AppEventsClientProtocol
    }

    private let foldersService: FoldersServiceProtocol
    private let appEventsClient: AppEventsClientProtocol

    init(dependencies: Dependencies) {
        foldersService = dependencies.foldersService
        appEventsClient = dependencies.appEventsClient
    }

    func fetchFolder(id: Int) async throws -> FolderModel {
        try await foldersService.fetchFolder(id: id)
    }

    func fetchFolders(filters: FolderFilters?) async throws -> [FolderModel] {
        try await foldersService.fetchFolders(filters: filters)
    }

    func createFolder(newFolder: NewFolderModel) async throws -> FolderModel {
        defer {
            appEventsClient.emit(FolderEvent.folderCreated)
        }

        return try await foldersService.createFolder(newFolder: newFolder)
    }

    func updateFolder(folder: UpdateFolderModel) async throws -> FolderModel {
        defer {
            appEventsClient.emit(FolderEvent.folderUpdated(id: folder.id))
        }

        return try await foldersService.updateFolder(folder: folder)
    }

    func remove(id: Int) async throws -> FolderModel {
        defer {
            appEventsClient.emit(FolderEvent.folderDeleted)
        }

        return try await foldersService.remove(id: id)
    }
}

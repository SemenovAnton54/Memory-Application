//
//  FoldersServiceProtocol.swift
//  Memory
//

import Foundation

struct FolderFilters {
    let isFavorite: Bool?
}

protocol FoldersServiceProtocol {
    func fetchFolder(id: Int) async throws -> FolderModel
    func fetchFolders(filters: FolderFilters?) async throws -> [FolderModel]

    func createFolder(newFolder: NewFolderModel) async throws -> FolderModel
    func updateFolder(folder: UpdateFolderModel) async throws -> FolderModel
    func remove(id: Int) async throws -> FolderModel
}


extension FoldersServiceProtocol {
    func fetchFolders() async throws -> [FolderModel] {
        try await fetchFolders(filters: nil)
    }
}

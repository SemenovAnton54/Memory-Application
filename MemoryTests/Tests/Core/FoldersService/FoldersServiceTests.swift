//
//  FoldersServiceTests.swift
//  Memory
//
//  Created by Anton Semenov on 21.01.2025.
//

import Testing
import Foundation
import SwiftData

@testable import Memory

@Suite("FoldersServiceTests Tests", .serialized)
class FoldersServiceTests {
    let container: ModelContainer
    let service: FoldersService

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: FolderEntity.self, configurations: config)

        service = FoldersService(modelContainer: container)
    }

    deinit {
        container.deleteAllData()
    }

    @Test("Create new item and Fetch item")
    func testCreateAndFetchNewFolder() async throws {
        let newModel = MockFolderModel.mockNewFolderModel()
        let model = try await service.createFolder(
            newFolder: newModel
        )

        #expect(model.isFavorite == newModel.isFavorite)
        #expect(model.name == newModel.name)
        #expect(model.desc == newModel.desc)
        #expect(model.icon == newModel.icon)
        #expect(model.image == newModel.image)

        let fetchedModel = try await service.fetchFolder(id: model.id)

        #expect(model.isFavorite == fetchedModel.isFavorite)
        #expect(model.name == fetchedModel.name)
        #expect(model.desc == fetchedModel.desc)
        #expect(model.icon == fetchedModel.icon)
        #expect(model.image == fetchedModel.image)
        #expect(model.id == fetchedModel.id)
    }

    @Test("Create new items, Fetch items and Delete items")
    func testCreateFetchAndDeleteNewFolders() async throws {
        let newModel = MockFolderModel.mockNewFolderModel()
        let newModelTwo = MockFolderModel.mockNewFolderModel(name: "Special name for model two", desc: "Special desc for model two")

        let modelOne = try await service.createFolder(
            newFolder: newModel
        )

        let modelTwo = try await service.createFolder(
            newFolder: newModelTwo
        )

        #expect(modelOne.isFavorite == newModel.isFavorite)
        #expect(modelOne.name == newModel.name)
        #expect(modelOne.desc == newModel.desc)
        #expect(modelOne.icon == newModel.icon)
        #expect(modelOne.image == newModel.image)

        let fetchedModelOne = try await service.fetchFolder(id: modelOne.id)
        #expect(modelOne.isFavorite == fetchedModelOne.isFavorite)
        #expect(modelOne.name == fetchedModelOne.name)
        #expect(modelOne.desc == fetchedModelOne.desc)
        #expect(modelOne.icon == fetchedModelOne.icon)
        #expect(modelOne.image == fetchedModelOne.image)
        #expect(modelOne.id == fetchedModelOne.id)

        let fetchedModelTwo = try await service.fetchFolder(id: modelTwo.id)
        #expect(modelTwo.isFavorite == fetchedModelTwo.isFavorite)
        #expect(modelTwo.name == fetchedModelTwo.name)
        #expect(modelTwo.desc == fetchedModelTwo.desc)
        #expect(modelTwo.icon == fetchedModelTwo.icon)
        #expect(modelTwo.image == fetchedModelTwo.image)
        #expect(modelTwo.id == fetchedModelTwo.id)

        let deletedModel = try await service.remove(id: modelOne.id)
        #expect(modelOne.isFavorite == deletedModel.isFavorite)
        #expect(modelOne.name == deletedModel.name)
        #expect(modelOne.desc == deletedModel.desc)
        #expect(modelOne.icon == deletedModel.icon)
        #expect(modelOne.image == deletedModel.image)
        #expect(modelOne.id == deletedModel.id)
    }

    @Test("Create new items, Fetch favorite and not favorite  items")
    func testCreateFetchNewFolders() async throws {
        let newModel = MockFolderModel.mockNewFolderModel(isFavorite: false)
        let newModelTwo = MockFolderModel.mockNewFolderModel(name: "Special name for model two", desc: "Special desc for model two", isFavorite: true)

        let modelOne = try await service.createFolder(
            newFolder: newModel
        )

        let modelTwo = try await service.createFolder(
            newFolder: newModelTwo
        )

        let favoriteItems = try await service.fetchFolders(filters: FolderFilters(isFavorite: true))
        #expect(favoriteItems.count == 1)
        #expect(favoriteItems[0].id == modelTwo.id)
        
        let nonFavoriteItems = try await service.fetchFolders(filters: FolderFilters(isFavorite: false))
        #expect(nonFavoriteItems.count == 1)
        #expect(nonFavoriteItems[0].id == modelOne.id)

        let allItems = try await service.fetchFolders(filters: nil)
        #expect(allItems.count == 2)
    }

    @Test(
        "Update item and Fetch item",
        arguments: [
            ("Name one", "Desc one", true, "😅", ImageType.local("test 1")),
            ("Name two", "Desc two", false, "😎", ImageType.local("test two")),
            ("Name Three", "Desc Three", true, "😅", ImageType.data(Data())),
            ("Name Four", nil, true, "😅", nil),
        ]
    )
    func testUpdateAndFetchNewFolder(
        name: String,
        desc: String?,
        isFavorite: Bool,
        icon: String,
        image: ImageType?
    ) async throws {
        let newModel = MockFolderModel.mockNewFolderModel()
        let model = try await service.createFolder(
            newFolder: newModel
        )

        let updateModel = MockFolderModel.mockUpdateFolderModel(
            id: model.id,
            name: name,
            desc: desc,
            isFavorite: isFavorite,
            icon: icon,
            image: image
        )

        let updatedModel = try await service.updateFolder(
            folder: updateModel
        )

        #expect(updatedModel.isFavorite == updateModel.isFavorite)
        #expect(updatedModel.name == updateModel.name)
        #expect(updatedModel.desc == updateModel.desc)
        #expect(updatedModel.icon == updateModel.icon)
        #expect(updatedModel.image == updateModel.image)
        #expect(updatedModel.id == updateModel.id)

        let fetchedModel = try await service.fetchFolder(id: model.id)

        #expect(updateModel.isFavorite == fetchedModel.isFavorite)
        #expect(updateModel.name == fetchedModel.name)
        #expect(updateModel.desc == fetchedModel.desc)
        #expect(updateModel.icon == fetchedModel.icon)
        #expect(updateModel.image == fetchedModel.image)
        #expect(updateModel.id == fetchedModel.id)
    }

    @Test("Fetch not existing Folder")
    func testFetchNotExistingFolder() async {
        var fetchError: Error?

        do {
            _ = try await service.fetchFolder(id: 1)
        } catch {
            fetchError = error
        }

        #expect((fetchError as! FoldersService.FoldersServiceError) == FoldersService.FoldersServiceError.folderNotExist)
    }

    @Test("remove not existing Folder")
    func testDeleteNotExistingFolder() async {
        var fetchError: Error?

        do {
            _ = try await service.remove(id: 1)
        } catch {
            fetchError = error
        }

        #expect((fetchError as! FoldersService.FoldersServiceError) == FoldersService.FoldersServiceError.folderNotExist)
    }

    @Test("update not existing Folder")
    func testUpdateNotExistingFolder() async {
        let updateModel = MockFolderModel.mockUpdateFolderModel(id: 99)

        var fetchError: Error?

        do {
            _ = try await service.updateFolder(
                folder: updateModel
            )
        } catch {
            fetchError = error
        }

        #expect((fetchError as! FoldersService.FoldersServiceError) == FoldersService.FoldersServiceError.folderNotExist)
    }
}

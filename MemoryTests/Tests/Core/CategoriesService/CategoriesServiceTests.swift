//
//  CategoriesServiceTests.swift
//  Memory
//
//  Created by Anton Semenov on 21.01.2025.
//

import Testing
import Foundation
import SwiftData

@testable import Memory

@Suite("CategoriesServiceTests Tests", .serialized)
class CategoriesServiceTests {
    let container: ModelContainer
    let service: CategoriesService

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: CategoryEntity.self, configurations: config)

        service = CategoriesService(modelContainer: container)
    }

    deinit {
        container.deleteAllData()
    }

    @Test("Create new item and Fetch item")
    func testCreateAndFetchNewCategory() async throws {
        let newModel = MockCategoryModel.mockNewCategoryModel()
        let model = try await service.createCategory(
            newCategory: newModel
        )

        #expect(model.folderId == newModel.folderId)
        #expect(model.name == newModel.name)
        #expect(model.desc == newModel.desc)
        #expect(model.icon == newModel.icon)
        #expect(model.image == newModel.image)

        let fetchedModel = try await service.fetchCategory(id: model.id)

        #expect(model.folderId == fetchedModel.folderId)
        #expect(model.name == fetchedModel.name)
        #expect(model.desc == fetchedModel.desc)
        #expect(model.icon == fetchedModel.icon)
        #expect(model.image == fetchedModel.image)
        #expect(model.id == fetchedModel.id)
    }

    @Test("Create new items, Fetch items and Delete items")
    func testCreateFetchAndDeleteNewCategorys() async throws {
        let newModel = MockCategoryModel.mockNewCategoryModel()
        let newModelTwo = MockCategoryModel.mockNewCategoryModel(name: "Special name for model two", desc: "Special desc for model two")

        let modelOne = try await service.createCategory(
            newCategory: newModel
        )

        let modelTwo = try await service.createCategory(
            newCategory: newModelTwo
        )

        #expect(modelOne.folderId == newModel.folderId)
        #expect(modelOne.name == newModel.name)
        #expect(modelOne.desc == newModel.desc)
        #expect(modelOne.icon == newModel.icon)
        #expect(modelOne.image == newModel.image)

        let fetchedModelOne = try await service.fetchCategory(id: modelOne.id)
        #expect(modelOne.folderId == fetchedModelOne.folderId)
        #expect(modelOne.name == fetchedModelOne.name)
        #expect(modelOne.desc == fetchedModelOne.desc)
        #expect(modelOne.icon == fetchedModelOne.icon)
        #expect(modelOne.image == fetchedModelOne.image)
        #expect(modelOne.id == fetchedModelOne.id)

        let fetchedModelTwo = try await service.fetchCategory(id: modelTwo.id)
        #expect(modelTwo.folderId == fetchedModelTwo.folderId)
        #expect(modelTwo.name == fetchedModelTwo.name)
        #expect(modelTwo.desc == fetchedModelTwo.desc)
        #expect(modelTwo.icon == fetchedModelTwo.icon)
        #expect(modelTwo.image == fetchedModelTwo.image)
        #expect(modelTwo.id == fetchedModelTwo.id)

        let deletedModel = try await service.remove(id: modelOne.id)
        #expect(modelOne.folderId == deletedModel.folderId)
        #expect(modelOne.name == deletedModel.name)
        #expect(modelOne.desc == deletedModel.desc)
        #expect(modelOne.icon == deletedModel.icon)
        #expect(modelOne.image == deletedModel.image)
        #expect(modelOne.id == deletedModel.id)

        var fetchError: Error?

        do {
            _ = try await service.fetchCategory(id: modelOne.id)
        } catch {
            fetchError = error
        }

        #expect((fetchError as! CategoriesService.CategoriesServiceError) == CategoriesService.CategoriesServiceError.categoryNotExist)
    }

    @Test(
        "Update item and Fetch item",
        arguments: [
            ("Name one", "Desc one", 1, "😅", ImageType.local("test 1")),
            ("Name two", "Desc two", 2, "😎", ImageType.local("test two")),
            ("Name Three", "Desc Three", 3, "😅", ImageType.data(Data())),
            ("Name Four", nil, nil, "😅", nil),
        ]
    )
    func testUpdateAndFetchNewCategory(
        name: String,
        desc: String?,
        folderId: Int?,
        icon: String,
        image: ImageType?
    ) async throws {
        let newModel = MockCategoryModel.mockNewCategoryModel()
        let model = try await service.createCategory(
            newCategory: newModel
        )

        let updateModel = MockCategoryModel.mockUpdateCategoryModel(
            id: model.id,
            folderId: folderId,
            name: name,
            desc: desc,
            icon: icon,
            image: image
        )

        let updatedModel = try await service.updateCategory(
            category: updateModel
        )

        #expect(updatedModel.folderId == updateModel.folderId)
        #expect(updatedModel.name == updateModel.name)
        #expect(updatedModel.desc == updateModel.desc)
        #expect(updatedModel.icon == updateModel.icon)
        #expect(updatedModel.image == updateModel.image)
        #expect(updatedModel.id == updateModel.id)

        let fetchedModel = try await service.fetchCategory(id: model.id)

        #expect(updateModel.folderId == fetchedModel.folderId)
        #expect(updateModel.name == fetchedModel.name)
        #expect(updateModel.desc == fetchedModel.desc)
        #expect(updateModel.icon == fetchedModel.icon)
        #expect(updateModel.image == fetchedModel.image)
        #expect(updateModel.id == fetchedModel.id)
    }

    @Test("Fetch not existing Category")
    func testFetchNotExistingCategory() async {
        var fetchError: Error?

        do {
            _ = try await service.fetchCategory(id: 1)
        } catch {
            fetchError = error
        }

        #expect((fetchError as! CategoriesService.CategoriesServiceError) == CategoriesService.CategoriesServiceError.categoryNotExist)
    }


    @Test("remove not existing Category")
    func testDeleteNotExistingCategory() async {
        var fetchError: Error?

        do {
            _ = try await service.remove(id: 1)
        } catch {
            fetchError = error
        }

        #expect((fetchError as! CategoriesService.CategoriesServiceError) == CategoriesService.CategoriesServiceError.categoryNotExist)
    }

    @Test("update not existing Category")
    func testUpdateNotExistingCategory() async {
        let updateModel = MockCategoryModel.mockUpdateCategoryModel(id: 99)

        var fetchError: Error?

        do {
            _ = try await service.updateCategory(
                category: updateModel
            )
        } catch {
            fetchError = error
        }

        #expect((fetchError as! CategoriesService.CategoriesServiceError) == CategoriesService.CategoriesServiceError.categoryNotExist)
    }
}

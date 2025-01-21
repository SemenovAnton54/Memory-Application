//
//  CategoriesService.swift
//  Memory
//

import Foundation
import SwiftData

@ModelActor
actor CategoriesService: CategoriesServiceProtocol {
    enum CategoriesServiceError: Error {
        case categoryNotExist
    }

    private var context: ModelContext { modelExecutor.modelContext }

    func fetchCategories(for folderId: Int) async throws -> [CategoryModel] {
        let categories = try context.fetch(FetchDescriptor<CategoryEntity>())

        return categories.map(CategoryModel.init)
    }

    func createCategory(newCategory: NewCategoryModel) async throws -> CategoryModel {
        let entity = CategoryEntity(
            id: try await maxId() + 1,
            folderId: newCategory.folderId,
            name: newCategory.name,
            desc: newCategory.desc,
            icon: newCategory.icon,
            image: newCategory.image
        )


        try perform {
            $0.insert(entity)
        }

        return CategoryModel(from: entity)
    }

    func fetchCategory(id: Int) async throws -> CategoryModel {
        guard let entity = try? fetchCategoryEntity(id: id) else {
            throw CategoriesServiceError.categoryNotExist
        }

        return CategoryModel(from: entity)
    }

    func updateCategory(category: UpdateCategoryModel) async throws -> CategoryModel {
        guard let entity = try? fetchCategoryEntity(id: category.id) else {
            throw CategoriesServiceError.categoryNotExist
        }

        entity.update(with: category)

        try perform {
            $0.insert(entity)
        }

        return CategoryModel(from: entity)

    }

    func remove(id: Int) async throws -> CategoryModel {
        guard let entity = try? fetchCategoryEntity(id: id) else {
            throw CategoriesServiceError.categoryNotExist
        }

        let model = CategoryModel(from: entity)
        try perform {
            $0.delete(entity)
        }

        return model
    }

    private func maxId() async throws -> Int {
        let categories = try context.fetch(FetchDescriptor<CategoryEntity>())

        return categories.map(\.id).max() ?? 0
    }

    private func fetchCategoryEntity(id: Int) throws -> CategoryEntity {
        let predicate = #Predicate<CategoryEntity> { object in
            object.id == id
        }

        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        let object = try context.fetch(descriptor)

        guard let first = object.first else {
            throw CategoriesServiceError.categoryNotExist
        }

        return first
    }

    private func perform(_ block: (ModelContext) -> ()) throws {
        block(context)
        try context.save()
    }
}

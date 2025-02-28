//
//  CategoriesServiceDecorator.swift
//  Memory
//

class CategoriesServiceDecorator: CategoriesServiceProtocol {
    struct Dependencies {
        let categoriesService: CategoriesServiceProtocol
        let appEventsClientProtocol: AppEventsClientProtocol
    }

    private let categoriesService: CategoriesServiceProtocol
    private let appEventsClientProtocol: AppEventsClientProtocol

    init(dependencies: Dependencies) {
        categoriesService = dependencies.categoriesService
        appEventsClientProtocol = dependencies.appEventsClientProtocol
    }

    func fetchCategory(id: Int) async throws -> CategoryModel {
        try await categoriesService.fetchCategory(id: id)
    }

    func fetchCategories(for folderId: Int) async throws -> [CategoryModel] {
        try await categoriesService.fetchCategories(for: folderId)
    }

    func createCategory(newCategory: NewCategoryModel) async throws -> CategoryModel {
        defer {
            appEventsClientProtocol.emit(CategoryEvent.categoryCreated)
        }

        return try await categoriesService.createCategory(newCategory: newCategory)
    }

    func updateCategory(category: UpdateCategoryModel) async throws -> CategoryModel {
        defer {
            appEventsClientProtocol.emit(CategoryEvent.categoryUpdated(id: category.id))
        }

        return try await categoriesService.updateCategory(category: category)
    }

    func remove(id: Int) async throws -> CategoryModel {
        defer {
            appEventsClientProtocol.emit(CategoryEvent.categoryDeleted(id: id))
        }

        return try await categoriesService.remove(id: id)
    }
}

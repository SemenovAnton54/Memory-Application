//
//  CategorieServiceProtocol.swift
//  Memory
//

import Foundation

protocol CategoriesServiceProtocol {
    func fetchCategory(id: Int) async throws -> CategoryModel
    func fetchCategories(for folderId: Int) async throws -> [CategoryModel]
    func createCategory(newCategory: NewCategoryModel) async throws -> CategoryModel
    func updateCategory(category: UpdateCategoryModel) async throws -> CategoryModel
    func remove(id: Int) async throws -> CategoryModel
}

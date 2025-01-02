//
//  CategoryDetailsEvent.swift
//  Memory
//

enum CategoryDetailsEvent {
    case categoryFetched(Result<CategoryModel, Error>)
    case categoryDeleted(Result<CategoryModel, Error>)
    case rememberItemsFetched(Result<[RememberCardItemModel], Error>)
    case rememberItemDeleted(Result<RememberCardItemModel, Error>)

    case addRememberItemTapped
    case editCategoryTapped
    case deleteCategoryTapped

    case categoryChanged

    case editRememberItemTapped(id: Int)
    case deleteRememberItemTapped(id: Int)
}

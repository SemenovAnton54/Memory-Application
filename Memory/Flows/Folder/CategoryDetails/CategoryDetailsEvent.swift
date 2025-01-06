//
//  CategoryDetailsEvent.swift
//  Memory
//

enum CategoryDetailsEvent {
    case categoryFetched(Result<CategoryModel, Error>)
    case categoryDeleted(Result<CategoryModel, Error>)
    
    case rememberItemsFetched(Result<[RememberCardItemModel], Error>)
    case rememberItemDeleted(Result<RememberCardItemModel, Error>)

    case addRememberItem
    case editCategory
    case deleteCategory

    case categoryChanged

    case editRememberItem(id: Int)
    case deleteRememberItem(id: Int)
}

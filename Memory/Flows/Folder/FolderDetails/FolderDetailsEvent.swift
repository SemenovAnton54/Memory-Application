//
//  FolderDetailsEvent.swift
//  Memory
//

enum FolderDetailsEvent {
    case folderDeleted(Result<FolderModel, Error>)
    case folderFetched(Result<FolderModel, Error>)

    case categoriesFetched(Result<[CategoryModel], Error>)

    case addCategory
    case editFolder
    case deleteFolder

    case categoryDetails(id: Int)

    case categoriesChanged
}

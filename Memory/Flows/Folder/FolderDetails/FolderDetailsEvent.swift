//
//  FolderDetailsEvent.swift
//  Memory
//

enum FolderDetailsEvent {
    case folderDeleted(Result<FolderModel, Error>)
    case folderFetched(Result<FolderModel, Error>)

    case categoriesFetched(Result<[CategoryModel], Error>)

    case addCategoryTapped
    case editFolderTapped
    case deleteFolderTapped

    case categoryDetailsTapped(id: Int)

    case categoriesChanged
}

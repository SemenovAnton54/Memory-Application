//
//  LearnMainEvent.swift
//  Memory
//

enum LearnMainEvent {
    case onAppear
    case refresh

    case showAllFolders
    case folderSelected(id: Int)
    case learnNewItems(folderId: Int)
    case reviewItems(folderId: Int)

    case foldersExist(Result<Bool, Error>)
    case favoriteFoldersFetched(Result<[LearnMainState.FavoriteFolderModel], Error>)
}

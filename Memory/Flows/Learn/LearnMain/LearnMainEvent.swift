//
//  LearnMainEvent.swift
//  Memory
//

enum LearnMainEvent {
    case onAppear
    case refresh
    case showAllFolders
    case folderSelected(id: Int)
    case foldersExist(Result<Bool, Error>)
    case favoriteFoldersFetched(Result<[FolderModel], Error>)
}

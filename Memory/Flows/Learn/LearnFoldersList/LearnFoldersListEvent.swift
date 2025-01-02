//
//  LearnFoldersListEvent.swift
//  Memory
//

enum LearnFoldersListEvent {
    case folderSelected(id: Int)
    case foldersFetched(Result<[FolderModel], Error>)
}

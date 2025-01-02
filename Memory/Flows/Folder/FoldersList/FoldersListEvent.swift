//
//  FoldersListEvent.swift
//  Memory
//

enum FoldersListEvent {
    case contentAppeared
    case newFolderTapped
    case folderChanged
    case folderSelected(id: Int)
    case foldersFetched(Result<[FolderModel], Error>)
}

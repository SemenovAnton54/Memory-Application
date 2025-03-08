//
//  FolderEvent.swift
//  Memory
//

enum FolderEvent: AppEvent, Equatable {
    case folderCreated
    case folderDeleted
    case folderUpdated(id: Int)
}

//
//  FoldersEvents.swift
//  Memory
//

enum RememberItemEvent: AppEvent {
    case rememberItemCreated
    case rememberItemUpdated(id: Int)
    case rememberItemDeleted(id: Int)
}

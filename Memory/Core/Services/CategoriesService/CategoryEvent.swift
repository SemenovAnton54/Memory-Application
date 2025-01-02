//
//  CategoryEvent.swift
//  Memory
//

enum CategoryEvent: AppEvent {
    case categoryCreated
    case categoryUpdated(id: Int)
    case categoryDeleted(id: Int)
}

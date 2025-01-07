//
//  LearnRoute.swift
//  Memory
//


import Foundation
import SwiftUI

enum LearnRoute: Hashable, Identifiable {
    case main
    case allFolders
    case selectMode(folderId: Int)
    case learnNewCards(folderId: Int)
    case reviewCards(folderId: Int)
    case editRememberItem(id: Int)

    var id: String {
        switch self {
        case .main:
            "main"
        case .allFolders:
            "allFolders"
        case let .selectMode(folderId):
            "selectMode_(\(folderId))"
        case let .learnNewCards(folderId):
            "learnNewCards_(\(folderId))"
        case let .reviewCards(folderId):
            "reviewCards_(\(folderId))"
        case let .editRememberItem(id):
            "editRememberItem_(\(id))"
        }
    }
}

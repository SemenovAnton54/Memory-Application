//
//  FoldersRoute.swift
//  Memory
//


import Foundation
import SwiftUI

enum FoldersRoute: Hashable, Identifiable {
    case foldersList

    case folderDetails(id: Int)
    case categoryDetails(id: Int)

    case editFolder(id: Int?)
    case editCategory(id: Int?, folderId: Int?)

    case editWordRememberItem(id: Int?, categoriesIds: [Int]?)

    var id: String {
        switch self {
        case .foldersList:
            return "foldersList"
        case let .folderDetails(id):
            return "folderDetails_\(id)"
        case let .categoryDetails(id):
            return "categoryDetails_\(id)"
        case let .editFolder(id):
            guard let id else {
                return "newFolder"
            }
            
            return "editFolder_\(id)"
        case let .editWordRememberItem(id, _):
            guard let id else {
                return "newWordRememberItem"
            }
            
            return "editWordRememberItem_\(id)"
        case let .editCategory(id, _):
            guard let id else {
                return "newCategory"
            }

            return "editCategory_\(id)"
        }
    }
}

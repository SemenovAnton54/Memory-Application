//
//  RememberItemRouter.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import Foundation
import SwiftUI

enum RememberItemRouter: Hashable, Identifiable {
    case editWordRememberItem(id: Int?, categoriesIds: [Int]?)
    case imagePicker(String?, completion: HashableWrapper<([ImageType]) -> ()>)

    var id: String {
        switch self {
        case let .editWordRememberItem(id, _):
            guard let id else {
                return "newWordRememberItem"
            }

            return "editWordRememberItem_\(id)"
        case let .imagePicker(text, _):
            return "imagePicker_\(text ?? "")"
        }
    }
}

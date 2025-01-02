//
//  UpdateCategoryModel.swift
//  Memory
//

import Foundation

struct UpdateCategoryModel {
    let id: Int
    let folderId: Int?
    let name: String
    let desc: String?
    let icon: String
    let image: ImageObject?

    init?(id: Int, folderId: Int?, name: String, desc: String?, icon: String, image: ImageObject?) {
        guard !name.isEmpty else {
            return nil
        }

        guard (icon.count < 2 && icon.first?.isEmoji == true) || icon.isEmpty else {
            return nil
        }

        self.id = id
        self.folderId = folderId
        self.name = name
        self.icon = icon
        self.desc = desc
        self.image = image
    }
}

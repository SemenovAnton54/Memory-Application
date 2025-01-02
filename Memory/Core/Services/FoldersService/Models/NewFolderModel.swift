//
//  NewFolderModel.swift
//  Memory
//

import Foundation

struct NewFolderModel {
    let name: String
    let desc: String?
    let isFavorite: Bool
    let icon: String
    let image: ImageObject?

    init?(name: String, desc: String?, isFavorite: Bool, icon: String, image: ImageObject?) {
        guard !name.isEmpty else {
            return nil
        }

        guard (icon.count < 2 && icon.first?.isEmoji == true) || icon.isEmpty else {
            return nil
        }

        self.name = name
        self.icon = icon
        self.desc = desc
        self.isFavorite = isFavorite
        self.image = image
    }
}

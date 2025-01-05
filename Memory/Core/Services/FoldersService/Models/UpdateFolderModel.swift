//
//  UpdateFolderModel.swift
//  Memory
//


import Foundation

struct UpdateFolderModel {
    let id: Int
    let name: String
    let desc: String?
    let isFavorite: Bool
    let icon: String
    let image: ImageType?

    init?(id: Int, name: String, desc: String?, isFavorite: Bool, icon: String, image: ImageType?) {
        guard !name.isEmpty else {
            return nil
        }

        guard (icon.count < 2 && icon.first?.isEmoji == true) || icon.isEmpty else {
            return nil
        }

        self.id = id
        self.name = name
        self.icon = icon
        self.desc = desc
        self.isFavorite = isFavorite
        self.image = image
    }
}

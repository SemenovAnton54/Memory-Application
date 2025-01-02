//
//  FolderModel.swift
//  Memory
//

import Foundation

struct FolderModel {
    let id: Int

    var name: String
    var desc: String?
    var isFavorite: Bool
    var icon: String?
    var image: ImageObject?

    init(from entity: FolderEntity) {
        id = entity.id
        name = entity.name
        desc = entity.desc
        isFavorite = entity.isFavorite
        icon = entity.icon
        image = entity.image
    }

    init (
        id: Int,
        name: String,
        desc: String?,
        isFavorite: Bool,
        icon: String?,
        image: ImageObject?
    ) {
        self.id = id
        self.name = name
        self.desc = desc
        self.isFavorite = isFavorite
        self.icon = icon
        self.image = image
    }
}

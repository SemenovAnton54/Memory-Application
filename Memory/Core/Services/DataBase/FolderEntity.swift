//
//  Folder.swift
//  Memory
//

import Foundation
import SwiftData

@Model
final class FolderEntity {
    @Attribute(.unique) var id: Int

    var name: String
    var desc: String?
    var isFavorite: Bool = false
    var icon: String?
    var image: ImageType?

    @Relationship(deleteRule: .deny)
    var categories: [CategoryEntity] = []

    init(
        id: Int,
        name: String,
        desc: String? = nil,
        isFavorite: Bool = false,
        icon: String?,
        image: ImageType? = nil
    ) {
        self.id = id
        self.name = name
        self.desc = desc
        self.isFavorite = isFavorite
        self.icon = icon
        self.image = image
    }

    init(model: FolderModel) {
        id = model.id
        name = model.name
        desc = model.desc
        isFavorite = model.isFavorite
        icon = model.icon
        image = model.image
    }

    func update(with model: UpdateFolderModel) {
        id = model.id
        name = model.name
        desc = model.desc
        isFavorite = model.isFavorite
        icon = model.icon
        image = model.image
    }
}

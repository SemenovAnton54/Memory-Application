//
//  CategoryEntity.swift
//  Memory
//

import Foundation
import SwiftData

@Model
final class CategoryEntity {
    @Attribute(.unique) var id: Int

    var folderId: Int?
    var name: String
    var isFavorite: Bool = false
    var desc: String?
    var icon: String?
    var image: ImageType?

    init(
        id: Int,
        folderId: Int?,
        name: String,
        desc: String? = nil,
        icon: String?,
        image: ImageType? = nil
    ) {
        self.id = id
        self.folderId = folderId
        self.name = name
        self.desc = desc
        self.icon = icon
        self.image = image
    }

    init(model: CategoryModel) {
        id = model.id
        folderId = model.folderId
        name = model.name
        desc = model.desc
        icon = model.icon
        image = model.image
    }

    func update(with model: UpdateCategoryModel) {
        id = model.id
        folderId = model.folderId
        name = model.name
        desc = model.desc
        icon = model.icon
        image = model.image
    }
}

//
//  CategoryModel.swift
//  Memory
//

import Foundation

struct CategoryModel {
    let id: Int
    
    var folderId: Int?
    var name: String
    var desc: String?
    var icon: String?
    var image: ImageType?

    init(from entity: CategoryEntity) {
        id = entity.id
        name = entity.name
        desc = entity.desc
        icon = entity.icon
        image = entity.image
    }

    init(
        id: Int,
        folderId: Int? = nil,
        name: String,
        desc: String? = nil,
        icon: String? = nil,
        image: ImageType? = nil
    ) {
        self.id = id
        self.folderId = folderId
        self.name = name
        self.desc = desc
        self.icon = icon
        self.image = image
    }
}

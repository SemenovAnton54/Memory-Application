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
    var image: ImageObject?

    init(from entity: CategoryEntity) {
        id = entity.id
        name = entity.name
        desc = entity.desc
        icon = entity.icon
        image = entity.image
    }
}

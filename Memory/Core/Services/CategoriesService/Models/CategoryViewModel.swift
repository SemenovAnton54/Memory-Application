//
//  CategoryViewModel.swift
//  Memory
//

import Foundation

struct CategoryViewModel: Identifiable {
    let id: Int
    let name: String
    let description: String
    let icon: String
    let image: ImageType?

    init(from model: CategoryModel) {
        id = model.id
        name = model.name
        description = model.desc ?? ""
        icon = model.icon ?? ""
        image = model.image
    }

    init(id: Int, name: String, description: String, icon: String, image: ImageType?) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.image = image
    }
}

//
//  FolderViewModel.swift
//  Memory
//

import Foundation

struct FolderViewModel: Identifiable {
    let id: Int
    let name: String
    let description: String
    let isFavorite: Bool
    let icon: String
    let image: ImageType?

    init(from model: FolderModel) {
        id = model.id
        name = model.name
        description = model.desc ?? ""
        isFavorite = model.isFavorite
        icon = model.icon ?? ""
        image = model.image
    }

    init(id: Int, name: String, description: String, isFavorite: Bool, icon: String, image: ImageType?) {
        self.id = id
        self.name = name
        self.description = description
        self.isFavorite = isFavorite
        self.icon = icon
        self.image = image
    }
}

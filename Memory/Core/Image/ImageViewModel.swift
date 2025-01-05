//
//  ImageViewModel.swift
//  Memory
//

struct ImageViewModel: Identifiable, Equatable {
    let id: Int
    let imageType: ImageType

    init(id: Int, imageType: ImageType) {
        self.id = id
        self.imageType = imageType
    }

    init(imageType: ImageType) {
        id = -1
        self.imageType = imageType
    }

    init(from: ImageModel) {
        id = from.id
        imageType = from.imageType
    }
}

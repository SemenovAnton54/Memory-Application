//
//  ImageViewModel.swift
//  Memory
//

struct ImageViewModel: Identifiable, Equatable {
    let id: Int
    let imageObject: ImageObject

    init(id: Int, imageObject: ImageObject) {
        self.id = id
        self.imageObject = imageObject
    }

    init(imageObject: ImageObject) {
        id = -1
        self.imageObject = imageObject
    }
}

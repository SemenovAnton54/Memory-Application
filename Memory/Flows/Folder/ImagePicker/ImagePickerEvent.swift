//
//  ImagePickerEvent.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import PhotosUI
import SwiftUI

enum ImagePickerEvent {
    case close
    case select
    case toggleImageSelection(id: Int)
    case removeImageFromGallery(id: Int)

    case imagesSelected
    case searchImages(String)
    case addImagesFromGallery(PhotosPickerItem?)
    case imageLoaded(Result<Data, Error>)
    case imagesFetched(Result<[ImageModel], Error>)
}

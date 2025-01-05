//
//  ImagePickerState.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI
import PhotosUI

struct ImagePickerState {
    struct ImagesRequest {
        let text: String
    }

    var text: String?
    var imagesFromGallery: [ImageModel] = []

    var images: [ImageModel] = []
    var selectedImagesIds: Set<Int> = []

    var loadImageRequest: FeedbackRequest<PhotosPickerItem>?
    var selectImagesRequest: FeedbackRequest<[ImageType]>?
    var fetchImagesRequest: FeedbackRequest<ImagesRequest>?
    var routingRequest: RoutingFeedbackRequest<ImagePickerRouterProtocol, ImagePickerEvent>?
}

extension ImagePickerState: RoutingStateProtocol {}

//
//  ImagePickerReducer.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import PhotosUI
import SwiftUI

struct ImagePickerReducer {
    typealias ImagesRequest = ImagePickerState.ImagesRequest

    func reduce(state: inout ImagePickerState, event: ImagePickerEvent) {
        switch event {
        case .close:
            onClose(state: &state)
        case let .imagesFetched(result):
            onImagesFetched(result: result, state: &state)
        case .select:
            onSelect(state: &state)
        case let .toggleImageSelection(id):
            onToggleImageSelection(id: id, state: &state)
        case let .removeImageFromGallery(id):
            onRemoveImageFromGallery(id: id, state: &state)
        case let .addImagesFromGallery(image):
            onAddImagesFromGallery(image, state: &state)
        case let .imageLoaded(result):
            onImageLoaded(result: result, state: &state)
        case let .searchImages(text):
            onSearchImages(text: text, state: &state)
        case .imagesSelected:
            onImagesSelected(state: &state)
        }
    }
}

// MARK: - Event handlers

private extension ImagePickerReducer {
    func onClose(state: inout ImagePickerState) {
        state.requestRoute {
            $0.close()
        }
    }

    func onImagesFetched(result: Result<[ImageModel], Error>, state: inout ImagePickerState) {
        state.fetchImagesRequest = nil

        switch result {
        case let .success(images):
            state.images = images
        case .failure:
            break
        }
    }

    func onImageLoaded(result: Result<Data, Error>, state: inout ImagePickerState) {
        state.loadImageRequest = nil

        switch result {
        case let .success(data):
            let id = state.imagesFromGallery.map(\.id).max() ?? 0
            state.imagesFromGallery.append(ImageModel(id: id + 1, imageType: .data(data)))
        case .failure:
            break
        }
    }

    func onSelect(state: inout ImagePickerState) {
        let images = state.imagesFromGallery + state.images.filter { state.selectedImagesIds.contains($0.id) }
        state.selectImagesRequest = FeedbackRequest(images.map(\.imageType))
    }

    func onAddImagesFromGallery(_ image: PhotosPickerItem?, state: inout ImagePickerState) {
        guard let image else {
            return
        }

        state.loadImageRequest = FeedbackRequest(image)
    }

    func onToggleImageSelection(id: Int, state: inout ImagePickerState) {
        guard state.selectedImagesIds.contains(id) else {
            state.selectedImagesIds.insert(id)
            return
        }

        state.selectedImagesIds.remove(id)
    }

    func onRemoveImageFromGallery(id: Int, state: inout ImagePickerState) {
        state.imagesFromGallery.removeAll(where: { $0.id == id })
    }

    func onSearchImages(text: String, state: inout ImagePickerState) {
        state.text = text
        state.fetchImagesRequest = FeedbackRequest(ImagesRequest(text: text))
    }

    func onImagesSelected(state: inout ImagePickerState) {
        state.selectImagesRequest = nil
        state.requestRoute {
            $0.close()
        }
    }
}


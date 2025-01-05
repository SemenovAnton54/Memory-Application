//
//  ImagePickerPresenter.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

struct ImagePickerPresenter {
    func present(state: ImagePickerState) -> ImagePickerViewState {
        ImagePickerViewState(
            searchText: state.text ?? "",
            customImages: state.imagesFromGallery.map {
                ImageViewModel(id: $0.id, imageType: $0.imageType)
            },
            imagesStates: state.images.map {
                ImagePickerViewState.ImageViewState(
                    imageViewModel: ImageViewModel(id: $0.id, imageType: $0.imageType),
                    isSelected: state.selectedImagesIds.contains($0.id)
                )
            },
            isLoading: state.fetchImagesRequest != nil
        )
    }
}

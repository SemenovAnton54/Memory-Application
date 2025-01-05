//
//  ImagePickerViewState.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

struct ImagePickerViewState {
    struct ImageViewState: Identifiable {
        var id: Int {
            imageViewModel.id
        }

        let imageViewModel: ImageViewModel
        let isSelected: Bool
    }

    let searchText: String
    let customImages: [ImageViewModel]
    let imagesStates: [ImageViewState]
    let isLoading: Bool
}

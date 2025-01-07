//
//  RememberItemCoordinatorState.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI
import Combine

final class RememberItemCoordinatorState: ObservableObject {
    @Published var route: RememberItemRouter

    @Published var nextItem: RememberItemRouter?
    @Published var presentedItem: RememberItemRouter?

    let onClose: () -> Void

    private weak var _nextCoordinatorState: RememberItemCoordinatorState?

    private weak var _imagePickerStore: DefaultMemorizeStore<ImagePickerState, ImagePickerEvent, ImagePickerViewState>?
    private weak var _editWordRememberItemStore: DefaultMemorizeStore<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState>?

    init(route: RememberItemRouter, onClose: @escaping () -> Void) {
        self.onClose = onClose
        self.route = route
    }

    @MainActor
    func editWordRememberItemStore(id: Int?, categoriesIds: [Int]?) -> DefaultMemorizeStore<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState> {
        guard let _editWordRememberItemStore else {
            let store = EditWordRememberItemFactory(
                dependencies: EditWordRememberItemFactory.Dependencies(rememberItemsService: MemoryApp.rememberItemsService)
            ).makeStore(
                arguments: EditWordRememberItemFactory.Arguments(
                    id: id,
                    categoriesIds: categoriesIds
                ),
                router: FolderDetailsRouter(state: self)
            )
            _editWordRememberItemStore = store

            return store
        }

        return _editWordRememberItemStore
    }

    @MainActor
    func imagePickerStore(text: String?, completion: HashableWrapper<([ImageType]) -> ()>) -> DefaultMemorizeStore<ImagePickerState, ImagePickerEvent, ImagePickerViewState> {
        guard let _imagePickerStore else {
            let store = ImagePickerFactory(
                dependencies: ImagePickerFactory.Dependencies(imagePickerService: MemoryApp.imagePickerService)
            ).makeStore(
                arguments: ImagePickerFactory.Arguments(text: text, onComplete: completion.value),
                router: ImagePickerRouter(state: self)
            )

            _imagePickerStore = store

            return store
        }

        return _imagePickerStore
    }

    func nextItemCoordinatorState(for route: RememberItemRouter) -> RememberItemCoordinatorState? {
        guard let nextItem else {
            return nil
        }

        guard let _nextCoordinatorState else {
            let state = RememberItemCoordinatorFactory().makeState(route: nextItem) { [weak self] in
                self?.nextItem = nil
            }

            _nextCoordinatorState = state

            return state
        }

        return _nextCoordinatorState
    }
}

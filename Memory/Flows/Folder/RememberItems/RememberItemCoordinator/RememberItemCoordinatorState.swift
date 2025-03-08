//
//  RememberItemCoordinatorState.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI
import Combine

final class RememberItemCoordinatorState: ObservableObject {
    struct Dependencies {
        let rememberItemCoordinatorFactory: RememberItemCoordinatorFactoryProtocol
        let editWordRememberItemFactory: EditWordRememberItemFactory
        let imagePickerFactory: ImagePickerFactory
    }

    private let dependencies: Dependencies

    private weak var _nextCoordinatorState: RememberItemCoordinatorState?

    private weak var _imagePickerStore: DefaultStateMachine<ImagePickerState, ImagePickerEvent, ImagePickerViewState>?
    private weak var _editWordRememberItemStore: DefaultStateMachine<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState>?

    let onClose: () -> Void

    @Published var route: RememberItemRouter

    @Published var nextItem: RememberItemRouter?
    @Published var presentedItem: RememberItemRouter?

    init(dependencies: Dependencies, route: RememberItemRouter, onClose: @escaping () -> Void) {
        self.dependencies = dependencies
        self.onClose = onClose
        self.route = route
    }

    @MainActor
    func editWordRememberItemStore(id: Int?, categoriesIds: [Int]?) -> DefaultStateMachine<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState> {
        guard let _editWordRememberItemStore else {
            let store = dependencies.editWordRememberItemFactory.makeStore(
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
    func imagePickerStore(text: String?, completion: HashableWrapper<([ImageType]) -> ()>) -> DefaultStateMachine<ImagePickerState, ImagePickerEvent, ImagePickerViewState> {
        guard let _imagePickerStore else {
            let store = dependencies.imagePickerFactory.makeStore(
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
            let state = dependencies.rememberItemCoordinatorFactory.makeState(route: nextItem) { [weak self] in
                self?.nextItem = nil
            }

            _nextCoordinatorState = state

            return state
        }

        return _nextCoordinatorState
    }
}

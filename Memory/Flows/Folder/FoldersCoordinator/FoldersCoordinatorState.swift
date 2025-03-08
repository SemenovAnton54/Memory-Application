//
//  FoldersCoordinatorState.swift
//  Memory
//

import SwiftUI
import Combine

final class FoldersCoordinatorState: ObservableObject {
    struct Dependencies {
        let foldersCoordinatorFactory: FoldersCoordinatorFactoryProtocol
        let rememberItemCoordinatorFactory: RememberItemCoordinatorFactoryProtocol
        let foldersListScreenFactory: FoldersListScreenFactory
        let editFolderFactory: EditFolderFactory
        let editCategoryFactory: EditCategoryFactory
        let folderDetailsFactory: FolderDetailsFactory
        let categoryDetailsFactory: CategoryDetailsFactory
    }

    @Published var route: FoldersRoute

    @Published var nextItem: FoldersRoute?
    @Published var presentedItem: FoldersRoute?

    let onClose: (() -> Void)?

    private let dependencies: Dependencies

    private weak var _nextCoordinatorState: FoldersCoordinatorState?

    private weak var _foldersListStore: (DefaultStateMachine<FoldersListState, FoldersListEvent, FoldersListViewState>)?

    private weak var _editFolderStore: (DefaultStateMachine<EditFolderState, EditFolderEvent, EditFolderViewState>)?
    private weak var _editCategoryStore: (DefaultStateMachine<EditCategoryState, EditCategoryEvent, EditCategoryViewState>)?

    private weak var _folderDetailsStore: DefaultStateMachine<FolderDetailsState, FolderDetailsEvent, FolderDetailsViewState>?
    private weak var _categoryDetailsStore: DefaultStateMachine<CategoryDetailsState, CategoryDetailsEvent, CategoryDetailsViewState>?

    private weak var _rememberItemCoordinatorState: RememberItemCoordinatorState?

    init(dependencies: Dependencies, route: FoldersRoute, onClose: (() -> Void)?) {
        self.dependencies = dependencies
        self.onClose = onClose
        self.route = route
    }

    @MainActor
    func foldersListStore() -> DefaultStateMachine<FoldersListState, FoldersListEvent, FoldersListViewState> {
        guard let _foldersListStore else {
            let store = dependencies.foldersListScreenFactory.makeStore(router: self)
            _foldersListStore = store

            return store
        }

        return _foldersListStore
    }

    @MainActor
    func folderStore(id: Int?) -> DefaultStateMachine<EditFolderState, EditFolderEvent, EditFolderViewState> {
        guard let _editFolderStore else {
            let store = dependencies.editFolderFactory.makeStore(id: id, router: self)
            _editFolderStore = store

            return store
        }

        return _editFolderStore
    }

    @MainActor
    func categoryStore(id: Int?, folderId: Int?) -> DefaultStateMachine<EditCategoryState, EditCategoryEvent, EditCategoryViewState> {
        guard let _editCategoryStore else {
            let store = dependencies.editCategoryFactory.makeStore(
                arguments: .init(
                    id: id,
                    folderId: folderId
                ),
                router: self
            )

            _editCategoryStore = store

            return store
        }

        return _editCategoryStore
    }

    @MainActor
    func folderDetailsStore(id: Int) -> DefaultStateMachine<FolderDetailsState, FolderDetailsEvent, FolderDetailsViewState> {
        guard let _folderDetailsStore else {
            let store = dependencies.folderDetailsFactory.makeStore(id: id, router: FolderDetailsRouter(state: self))
            _folderDetailsStore = store
            
            return store
        }

        return _folderDetailsStore
    }

    @MainActor
    func categoryDetailsStore(id: Int) -> DefaultStateMachine<CategoryDetailsState, CategoryDetailsEvent, CategoryDetailsViewState> {
        guard let _categoryDetailsStore else {
            let store = dependencies.categoryDetailsFactory.makeStore(
                arguments: .init(id: id),
                router: CategoryDetailsRouter(state: self)
            )
            _categoryDetailsStore = store

            return store
        }

        return _categoryDetailsStore
    }

    @MainActor
    func rememberItemCoordinatorState(router: RememberItemRouter) -> RememberItemCoordinatorState {
        guard let _rememberItemCoordinatorState else {
            let store = dependencies.rememberItemCoordinatorFactory.makeState(route: router) { [weak self] in
                self?.presentedItem = nil
            }
            _rememberItemCoordinatorState = store

            return store
        }

        return _rememberItemCoordinatorState
    }

    func nextItemCoordinatorState(for route: FoldersRoute) -> FoldersCoordinatorState? {
        guard let nextItem else {
            return nil
        }

        guard let _nextCoordinatorState else {
            let state = dependencies.foldersCoordinatorFactory.makeState(
                for: nextItem
            ) { [weak self] in
                self?.nextItem = nil
            }
            
            _nextCoordinatorState = state

            return state
        }

        return _nextCoordinatorState
    }
}

extension FoldersCoordinatorState: FoldersListRouterProtocol,
        EditFolderRouterProtocol,
        EditCategoryRouterProtocol {
    func editCategory(id: Int) {
        presentedItem = .editCategory(id: id, folderId: nil)
    }

    func newRememberItem(for category: Int) {
        presentedItem = .editWordRememberItem(id: nil, categoriesIds: [category])
    }

    func rememberItemDetails(id: Int) {
        presentedItem = .editWordRememberItem(id: id, categoriesIds: nil)
    }

    func newCategory(for folder: Int) {
        presentedItem = .editCategory(id: nil, folderId: folder)
    }
    
    func categoryDetails(id: Int) {
        nextItem = .categoryDetails(id: id)
    }
    
    func editFolder(id: Int) {
        presentedItem = .editFolder(id: id)
    }
    
    func openFolder(id: Int) {
        nextItem = .folderDetails(id: id)
    }

    func newFolder() {
        presentedItem = .editFolder(id: nil)
    }

    func close() {
        presentedItem = nil
    }
}

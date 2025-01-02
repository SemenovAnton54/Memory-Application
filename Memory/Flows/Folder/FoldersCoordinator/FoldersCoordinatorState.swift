//
//  FoldersCoordinatorState.swift
//  Memory
//

import SwiftUI
import Combine

final class FoldersCoordinatorState: ObservableObject {
    @Published var route: FoldersRoute

    @Published var nextItem: FoldersRoute?
    @Published var presentedItem: FoldersRoute?

    let onClose: () -> Void

    private weak var _nextCoordinatorState: FoldersCoordinatorState?

    private weak var _foldersListStore: (DefaultMemorizeStore<FoldersListState, FoldersListEvent, FoldersListViewState>)? = nil

    private weak var _editFolderStore: (DefaultMemorizeStore<EditFolderState, EditFolderEvent, EditFolderViewState>)? = nil
    private weak var _editCategoryStore: (DefaultMemorizeStore<EditCategoryState, EditCategoryEvent, EditCategoryViewState>)? = nil

    private weak var _folderDetailsStore: DefaultMemorizeStore<FolderDetailsState, FolderDetailsEvent, FolderDetailsViewState>? = nil
    private weak var _categoryDetailsStore: DefaultMemorizeStore<CategoryDetailsState, CategoryDetailsEvent, CategoryDetailsViewState>? = nil

    private weak var _editWordRememberItemStore: DefaultMemorizeStore<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState>? = nil

    init(route: FoldersRoute, onClose: @escaping () -> Void) {
        self.onClose = onClose
        self.route = route
    }

    func foldersListStore() -> DefaultMemorizeStore<FoldersListState, FoldersListEvent, FoldersListViewState> {
        guard let _foldersListStore else {
            let store = FoldersListScreenFactory(
                dependencies: FoldersListScreenFactory.Dependencies(
                    foldersService: MemoryApp.foldersService,
                    appEventsClient: MemoryApp.appEventsClient()
                )
            )
                .makeStore(router: self)
            _foldersListStore = store

            return store
        }

        return _foldersListStore
    }

    func folderStore(id: Int?) -> DefaultMemorizeStore<EditFolderState, EditFolderEvent, EditFolderViewState> {
        guard let _editFolderStore else {
            let store = EditFolderFactory(
                dependencies: EditFolderFactory.Dependencies(
                    foldersService: MemoryApp.foldersService
                )
            ).makeStore(id: id, router: self)

            _editFolderStore = store

            return store
        }

        return _editFolderStore
    }

    func categoryStore(id: Int?, folderId: Int?) -> DefaultMemorizeStore<EditCategoryState, EditCategoryEvent, EditCategoryViewState> {
        guard let _editCategoryStore else {
            let store = EditCategoryFactory(
                dependencies: EditCategoryFactory.Dependencies(categoriesService: MemoryApp.categoriesService)
            ).makeStore(
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

    func folderDetailsStore(id: Int) -> DefaultMemorizeStore<FolderDetailsState, FolderDetailsEvent, FolderDetailsViewState> {
        guard let _folderDetailsStore else {
            let store = FolderDetailsFactory(
                dependencies: FolderDetailsFactory.Dependencies(
                    foldersService: MemoryApp.foldersService,
                    categoriesService: MemoryApp.categoriesService,
                    appEventsClient: MemoryApp.appEventsClient()
                )
            ).makeStore(id: id, router: FolderDetailsRouter(state: self))
            _folderDetailsStore = store
            
            return store
        }

        return _folderDetailsStore
    }

    func categoryDetailsStore(id: Int) -> DefaultMemorizeStore<CategoryDetailsState, CategoryDetailsEvent, CategoryDetailsViewState> {
        guard let _categoryDetailsStore else {
            let store = CategoryDetailsFactory(
                dependencies: .init(
                    categoriesService: MemoryApp.categoriesService,
                    rememberItemsService: MemoryApp.rememberItemsService,
                    appEventsClient: MemoryApp.appEventsClient()
                )
            ).makeStore(arguments: .init(id: id), router: CategoryDetailsRouter(state: self))
            _categoryDetailsStore = store

            return store
        }

        return _categoryDetailsStore
    }

    func editWordRememberItemStore(id: Int?, categoriesIds: [Int]?) -> DefaultMemorizeStore<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState> {
        guard let _editWordRememberItemStore else {
            let store = EditWordRememberItemFactory(
                dependencies: EditWordRememberItemFactory.Dependencies(rememberItemsService: MemoryApp.rememberItemsService)
            ).makeStore(
                arguments: EditWordRememberItemFactory.Arguments(
                    id: id,
                    categoriesIds: categoriesIds
                ),
                router: self
            )
            _editWordRememberItemStore = store

            return store
        }

        return _editWordRememberItemStore
    }

    func nextItemCoordinatorState(for route: FoldersRoute) -> FoldersCoordinatorState? {
        guard let nextItem else {
            return nil
        }

        guard let _nextCoordinatorState else {
            let state = FoldersCoordinatorFactory().makeState(route: nextItem) { [weak self] in
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
        EditCategoryRouterProtocol,
        EditWordRememberItemRouterProtocol {
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

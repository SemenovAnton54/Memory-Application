//
//  LearnCoordinatorState.swift
//  Memory
//

import SwiftUI
import Combine

final class LearnCoordinatorState: ObservableObject {
    @Published var route: LearnRoute

    @Published var nextItem: LearnRoute?
    @Published var presentedItem: LearnRoute?

    private weak var nextCoordinatorState: LearnCoordinatorState?

    private weak var _learnMainStore: DefaultMemorizeStore<LearnMainState, LearnMainEvent, LearnMainViewState>? = nil
    private weak var _startFolderLearningModeStore: DefaultMemorizeStore<SelectFolderLearningModeState, SelectFolderLearningModeEvent, SelectFolderLearningModeViewState>? = nil
    private weak var _learnNewCardsStore: DefaultMemorizeStore<LearnCardState, LearnCardEvent, LearnCardViewState>? = nil
    private weak var _reviewCardsStore: DefaultMemorizeStore<LearnCardState, LearnCardEvent, LearnCardViewState>? = nil
    private weak var _editWordRememberItemStore: DefaultMemorizeStore<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState>? = nil
    private weak var _learnFoldersListStore: DefaultMemorizeStore<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState>? = nil

    let onClose: () -> Void
    
    init(route: LearnRoute, onClose: @escaping () -> Void) {
        self.route = route
        self.onClose = onClose
    }

    func learnMainStore() -> DefaultMemorizeStore<LearnMainState, LearnMainEvent, LearnMainViewState> {
        guard let _learnMainStore else {
            let store = LearnMainFactory(
                dependencies: LearnMainFactory.Dependencies(
                    foldersService: MemoryApp.foldersService,
                    appEventsClient: MemoryApp.appEventsClient()
                )
            )
                .makeStore(router: LearnMainRouter(state: self))
            _learnMainStore = store

            return store
        }

        return _learnMainStore
    }

    func startFolderLearningModeStore(folderId: Int) -> DefaultMemorizeStore<SelectFolderLearningModeState, SelectFolderLearningModeEvent, SelectFolderLearningModeViewState> {
        guard let _startFolderLearningModeStore else {
            let store = SelectFolderLearningModeFactory(
                dependencies: SelectFolderLearningModeFactory.Dependencies()
            ).makeStore(
                arguments: SelectFolderLearningModeFactory.Arguments(folderId: folderId),
                router: self
            )
            _startFolderLearningModeStore = store

            return store
        }

        return _startFolderLearningModeStore
    }

    func learnFoldersListStore() -> DefaultMemorizeStore<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState> {
        guard let _learnFoldersListStore else {
            let store = LearnFoldersListFactory(
                dependencies: LearnFoldersListFactory.Dependencies(
                    foldersService: MemoryApp.foldersService
                )
            ).makeStore(
                router: LearnFoldersListRouter(state: self)
            )
            _learnFoldersListStore = store

            return store
        }

        return _learnFoldersListStore
    }

    func learnNewCards(folderId: Int) -> DefaultMemorizeStore<LearnCardState, LearnCardEvent, LearnCardViewState> {
        guard let _learnNewCardsStore else {
            let store = LearnCardFactory(
                dependencies: LearnCardFactory.Dependencies(
                    speechUtteranceService: MemoryApp.speechUtteranceService,
                    appEventsClient: MemoryApp.appEventsClient(),
                    rememberItemsService: MemoryApp.rememberItemsService
                )
            ).makeStore(
                arguments: .init(
                    folderId: folderId,
                    mode: .learnNew
                ),
                router: LearnCardRouter(state: self)
            )
            _learnNewCardsStore = store

            return store
        }

        return _learnNewCardsStore
    }

    func reviewCards(folderId: Int) -> DefaultMemorizeStore<LearnCardState, LearnCardEvent, LearnCardViewState> {
        guard let _reviewCardsStore else {
            let store = LearnCardFactory(
                dependencies: LearnCardFactory.Dependencies(
                    speechUtteranceService: MemoryApp.speechUtteranceService,
                    appEventsClient: MemoryApp.appEventsClient(),
                    rememberItemsService: MemoryApp.rememberItemsService
                )
            ).makeStore(
                arguments: .init(
                    folderId: folderId,
                    mode: .review
                ),
                router: LearnCardRouter(state: self)
            )
            _reviewCardsStore = store

            return store
        }

        return _reviewCardsStore
    }

    func nextItemCoordinatorState(for route: LearnRoute) -> LearnCoordinatorState? {
        guard let nextCoordinatorState else {
            let state = LearnCoordinatorFactory().makeState(route: route) { [weak self] in
                self?.nextItem = nil
            }
            
            nextCoordinatorState = state

            return state
        }

        return nextCoordinatorState
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
}

extension LearnCoordinatorState: SelectFolderLearningModeRouterProtocol, EditWordRememberItemRouterProtocol {
    func learnNewCards(folderId: Int) {
        nextItem = .learnNewCards(folderId: folderId)
    }
    
    func reviewCrds(folderId: Int) {
        nextItem = .reviewCards(folderId: folderId)
    }
    
    func close() {
        presentedItem = nil
    }
}

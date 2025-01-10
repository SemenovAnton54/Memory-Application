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

    private weak var _learnMainStore: DefaultStateMachine<LearnMainState, LearnMainEvent, LearnMainViewState>? = nil
    private weak var _startFolderLearningModeStore: DefaultStateMachine<SelectFolderLearningModeState, SelectFolderLearningModeEvent, SelectFolderLearningModeViewState>? = nil
    private weak var _learnNewCardsStore: DefaultStateMachine<LearnCardState, LearnCardEvent, LearnCardViewState>? = nil
    private weak var _reviewCardsStore: DefaultStateMachine<LearnCardState, LearnCardEvent, LearnCardViewState>? = nil
    private weak var _learnFoldersListStore: DefaultStateMachine<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState>? = nil
    private weak var _rememberItemCoordinatorState: RememberItemCoordinatorState?

    let onClose: () -> Void
    
    init(route: LearnRoute, onClose: @escaping () -> Void) {
        self.route = route
        self.onClose = onClose
    }

    @MainActor
    func learnMainStore() -> DefaultStateMachine<LearnMainState, LearnMainEvent, LearnMainViewState> {
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

    @MainActor
    func startFolderLearningModeStore(folderId: Int) -> DefaultStateMachine<SelectFolderLearningModeState, SelectFolderLearningModeEvent, SelectFolderLearningModeViewState> {
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

    @MainActor
    func learnFoldersListStore() -> DefaultStateMachine<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState> {
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

    @MainActor
    func learnNewCards(folderId: Int) -> DefaultStateMachine<LearnCardState, LearnCardEvent, LearnCardViewState> {
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

    @MainActor
    func reviewCards(folderId: Int) -> DefaultStateMachine<LearnCardState, LearnCardEvent, LearnCardViewState> {
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

    @MainActor
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

    @MainActor
    func rememberItemCoordinatorState(router: RememberItemRouter) -> RememberItemCoordinatorState {
        guard let _rememberItemCoordinatorState else {
            let store = RememberItemCoordinatorState(route: router) { [weak self] in
                self?.presentedItem = nil
            }
            _rememberItemCoordinatorState = store

            return store
        }

        return _rememberItemCoordinatorState
    }
}

extension LearnCoordinatorState: SelectFolderLearningModeRouterProtocol {
    func learnNewCards(folderId: Int) {
        nextItem = .learnNewCards(folderId: folderId)
    }
    
    func reviewCards(folderId: Int) {
        nextItem = .reviewCards(folderId: folderId)
    }
    
    func close() {
        presentedItem = nil
    }
}

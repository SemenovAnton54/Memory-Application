//
//  CoordinatorRootState.swift
//  Memory
//

import SwiftUI
import Combine

final class CoordinatorRootState: ObservableObject {
    struct Dependencies {
        let foldersCoordinatorFactory: any FoldersCoordinatorFactoryProtocol
    }

    @Published var path = NavigationPath()
    @Published var presentedItem: RootRouter?

    private let dependencies: Dependencies

    private weak var _foldersCoordinatorState: FoldersCoordinatorState? = nil
    private weak var _learnCoordinatorState: LearnCoordinatorState? = nil

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func foldersCoordinatorState() -> FoldersCoordinatorState {
        guard let _foldersCoordinatorState else {
            let state = dependencies.foldersCoordinatorFactory.makeState(for: .foldersList) {}
            _foldersCoordinatorState = state

            return state
        }

        return _foldersCoordinatorState
    }

    func learnCoordinatorState() -> LearnCoordinatorState {
        guard let _learnCoordinatorState else {
            let state = LearnCoordinatorFactory().makeState(route: .main) {

            }
            _learnCoordinatorState = state

            return state
        }

        return _learnCoordinatorState
    }
}

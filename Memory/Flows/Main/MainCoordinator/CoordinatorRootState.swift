//
//  CoordinatorRootState.swift
//  Memory
//

import SwiftUI
import Combine

final class CoordinatorRootState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedItem: RootRouter?

    private weak var _foldersCoordinatorState: FoldersCoordinatorState? = nil
    private weak var _learnCoordinatorState: LearnCoordinatorState? = nil

    func foldersCoordinatorState() -> FoldersCoordinatorState {
        guard let _foldersCoordinatorState else {
            let state = FoldersCoordinatorFactory().makeState(route: .foldersList) {
                
            }
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

//
//  LearnMainPresenter.swift
//  Memory
//

struct LearnMainPresenter {
    func present(state: LearnMainState) -> LearnMainViewState {
        LearnMainViewState(
            favoriteFolders: state.favoriteFolders.map { FolderViewModel(from: $0) },
            isFoldersExists: isFoldersExists(state: state)
        )
    }
}

extension LearnMainPresenter {
    func isFoldersExists(state: LearnMainState) -> Bool {
        state.foldersExistsRequest == nil && state.foldersExists
    }
}

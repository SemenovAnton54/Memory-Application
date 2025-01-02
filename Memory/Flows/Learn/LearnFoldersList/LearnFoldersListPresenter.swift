//
//  LearnFoldersListPresenter.swift
//  Memory
//

struct LearnFoldersListPresenter {
    func present(state: LearnFoldersListState) -> LearnFoldersListViewState {
        LearnFoldersListViewState(
            folders: state.folders.map(FolderViewModel.init(from:))
        )
    }
}

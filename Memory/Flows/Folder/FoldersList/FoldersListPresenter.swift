//
//  FoldersListPresenter.swift
//  Memory
//

struct FoldersListPresenter {
    func present(state: FoldersListState) -> FoldersListViewState {
        FoldersListViewState(
            favoriteFolders: state.folders.map(FolderViewModel.init(from:))
        )
    }
}

//
//  FolderDetailsPresenter.swift
//  Memory
//

struct FolderDetailsPresenter {
    func present(state: FolderDetailsState) -> FolderDetailsViewState {
        FolderDetailsViewState(
            folder: folder(state: state),
            categories: categories(state: state)
        )
    }
}

extension FolderDetailsPresenter {
    func folder(state: FolderDetailsState) -> FolderViewModel? {
        guard let folder = state.folder else {
            return nil
        }

        return FolderViewModel(from: folder)
    }

    func categories(state: FolderDetailsState) -> [CategoryViewModel] {
        state.categories.map(CategoryViewModel.init(from:))
    }
}

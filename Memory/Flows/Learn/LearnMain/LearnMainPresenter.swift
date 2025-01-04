//
//  LearnMainPresenter.swift
//  Memory
//

struct LearnMainPresenter {
    func present(state: LearnMainState) -> LearnMainViewState {
        LearnMainViewState(
            favoriteFolders: state.favoriteFolders.map {
                FavoriteFolderViewModel(
                    folder: FolderViewModel(from: $0.folder),
                    learnedNewItemsTodayCount: $0.newCardsStatistics.learnedCount,
                    itemToReviewCount: $0.reviewCardsStatistics.toLearnCount,
                    reviewedItemsTodayCount: $0.reviewCardsStatistics.learnedCount
                )
            },
            isFoldersExists: isFoldersExists(state: state)
        )
    }
}

extension LearnMainPresenter {
    func isFoldersExists(state: LearnMainState) -> Bool {
        state.foldersExistsRequest == nil && state.foldersExists
    }
}

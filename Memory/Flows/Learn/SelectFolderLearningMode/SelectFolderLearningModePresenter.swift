//
//  SelectFolderLearningModePresenter.swift
//  Memory
//

struct SelectFolderLearningModePresenter {
    func present(state: SelectFolderLearningModeState) -> SelectFolderLearningModeViewState {
        SelectFolderLearningModeViewState(
            learnedNewItemsTodayCount: learnedNewItemsTodayCount(state: state),
            reviewedItemsTodayCount: reviewedItemsTodayCount(state: state),
            itemToReviewCount: itemToReviewCount(state: state)
        )
    }
}

extension SelectFolderLearningModePresenter {
    func learnedNewItemsTodayCount(state: SelectFolderLearningModeState) -> Int {
        state.newItemsStatistics?.learnedCount ?? 0
    }

    func reviewedItemsTodayCount(state: SelectFolderLearningModeState) -> Int {
        state.reviewItemsStatistics?.learnedCount ?? 0
    }

    func itemToReviewCount(state: SelectFolderLearningModeState) -> Int {
        state.reviewItemsStatistics?.toLearnCount ?? 0
    }
}

//
//  SelectFolderLearningModeReducer.swift
//  Memory
//

struct SelectFolderLearningModeReducer {
    func reduce(state: inout SelectFolderLearningModeState, event: SelectFolderLearningModeEvent) {
        switch event {
        case .learnNewCards:
            onLearnNewCards(state: &state)
        case .reviewCards:
            onReviewCards(state: &state)
        case let .newCardItemsStatisticsFetched(result):
            onNewCardItemsStatisticsFetched(result: result, state: &state)
        case let .reviewCardItemsStatisticsFetched(result):
            onReviewCardItemsStatisticsFetched(result: result, state: &state)
        }
    }
}

// MARK: - Event handlers

private extension SelectFolderLearningModeReducer {
    func onLearnNewCards(state: inout SelectFolderLearningModeState) {
        let folderId = state.folderId

        state.requestRoute {
            $0.learnNewCards(folderId: folderId)
        }
    }

    func onReviewCards(state: inout SelectFolderLearningModeState) {
        let folderId = state.folderId

        state.requestRoute {
            $0.reviewCards(folderId: folderId)
        }
    }

    func onNewCardItemsStatisticsFetched(result: Result<LearnStatisticsModel, Error>, state: inout SelectFolderLearningModeState) {
        state.fetchNewItemsStatisticsRequest = nil

        switch result {
        case let .success(statistics):
            state.newItemsStatistics = statistics
        case .failure:
            break
        }
    }

    func onReviewCardItemsStatisticsFetched(result: Result<LearnStatisticsModel, Error>, state: inout SelectFolderLearningModeState) {
        state.fetchReviewItemsStatisticsRequest = nil

        switch result {
        case let .success(statistics):
            state.reviewItemsStatistics = statistics
        case .failure:
            break
        }
    }
}

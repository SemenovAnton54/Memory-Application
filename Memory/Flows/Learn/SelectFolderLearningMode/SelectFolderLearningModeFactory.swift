//
//  SelectFolderLearningModeFactory.swift
//  Memory
//

struct SelectFolderLearningModeFactory {
    struct Arguments {
        let folderId: Int
    }

    struct Dependencies {
        
    }

    let dependencies: Dependencies

    @MainActor
    func makeStore(
        arguments: Arguments,
        router: SelectFolderLearningModeRouterProtocol
    ) -> DefaultMemorizeStore<SelectFolderLearningModeState, SelectFolderLearningModeEvent, SelectFolderLearningModeViewState> {
        let newCardItemsService = MemoryApp.learnNewItemsService
        let reviewCardItemsService = MemoryApp.reviewItemsService

        let store = DefaultMemorizeStore(
            initialState: SelectFolderLearningModeState(
                folderId: arguments.folderId,
                fetchNewItemsStatisticsRequest: FeedbackRequest(),
                fetchReviewItemsStatisticsRequest: FeedbackRequest()
            ),
            reduce: SelectFolderLearningModeReducer().reduce,
            present: SelectFolderLearningModePresenter().present,
            feedback: [
                makeRoutingLoop(router: router),
                makeFetchNewCardItemsStatisticsSLoop(folder: arguments.folderId, learnService: newCardItemsService),
                makeFetchReviewCardItemsStatisticsSLoop(folder: arguments.folderId, learnService: reviewCardItemsService),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias SelectFolderLearningModeFeedbackLoop = FeedbackLoop<SelectFolderLearningModeState, SelectFolderLearningModeEvent>

extension SelectFolderLearningModeFactory {
    func makeFetchNewCardItemsStatisticsSLoop(folder: Int, learnService: LearnCardsServiceProtocol) -> SelectFolderLearningModeFeedbackLoop {
        react(request: \.fetchNewItemsStatisticsRequest) {
            do {
                let item = try await learnService.fetchStatistics(for: folder)

                return .newCardItemsStatisticsFetched(.success(item))
            } catch {
                return .newCardItemsStatisticsFetched(.failure(error))
            }
        }
    }

    func makeFetchReviewCardItemsStatisticsSLoop(folder: Int, learnService: LearnCardsServiceProtocol) -> SelectFolderLearningModeFeedbackLoop {
        react(request: \.fetchNewItemsStatisticsRequest) {
            do {
                let item = try await learnService.fetchStatistics(for: folder)

                return .reviewCardItemsStatisticsFetched(.success(item))
            } catch {
                return .reviewCardItemsStatisticsFetched(.failure(error))
            }
        }
    }
}

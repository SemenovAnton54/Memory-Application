//
//  LearnMainFactory.swift
//  Memory
//

import Combine

struct LearnMainFactory {
    struct Dependencies {
        let foldersService: FoldersServiceProtocol
        let appEventsClient: AppEventsClientProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        router: LearnMainRouterProtocol
    ) -> DefaultMemorizeStore<LearnMainState, LearnMainEvent, LearnMainViewState> {
        let newCardItemsService = MemoryApp.learnNewItemsService
        let reviewCardItemsService = MemoryApp.reviewItemsService

        let store = DefaultMemorizeStore(
            initialState: LearnMainState(fetchFavoriteFoldersRequest: FeedbackRequest()),
            reduce: LearnMainReducer().reduce,
            present: LearnMainPresenter().present,
            feedback: [
                makeRoutingLoop(router: router),
                makeFetchFavoriteFoldersRequestLoop(learnNewCardsService: newCardItemsService, reviewCardsService: reviewCardItemsService),
                makeFoldersExistsRequestLoop(),
                makeFolderEventsLoop(),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias LearnMainFeedbackLoop = FeedbackLoop<LearnMainState, LearnMainEvent>

extension LearnMainFactory {
    func makeFetchFavoriteFoldersRequestLoop(
        learnNewCardsService: LearnCardsServiceProtocol,
        reviewCardsService: LearnCardsServiceProtocol
    ) -> LearnMainFeedbackLoop {
        react(request: \.fetchFavoriteFoldersRequest) { request in
            do {
                let folders = try await dependencies.foldersService.fetchFolders(filters: FolderFilters(isFavorite: true))

                var favoriteFolderModels: [LearnMainState.FavoriteFolderModel] = []

                for folder in folders {
                    let newCardsStatistics = try await learnNewCardsService.fetchStatistics(for: folder.id)
                    let reviewCardsStatistics = try await  reviewCardsService.fetchStatistics(for: folder.id)

                    favoriteFolderModels.append(
                        LearnMainState.FavoriteFolderModel(
                            folder: folder,
                            newCardsStatistics: newCardsStatistics,
                            reviewCardsStatistics: reviewCardsStatistics
                        )
                    )
                }

                return .favoriteFoldersFetched(.success(favoriteFolderModels))
            } catch {
                return .favoriteFoldersFetched(.failure(error))
            }
        }
    }

    func makeFoldersExistsRequestLoop() -> LearnMainFeedbackLoop {
        react(request: \.foldersExistsRequest) { request in
            do {
                let folders = try await dependencies.foldersService.fetchFolders()

                return .foldersExist(.success(!folders.isEmpty))
            } catch {
                return .foldersExist(.failure(error))
            }
        }
    }

    func makeFolderEventsLoop() -> LearnMainFeedbackLoop {
        feedbackLoop { _ in
            Publishers.MergeMany(
                dependencies
                    .appEventsClient
                    .subscribe(for: CategoryEvent.self)
                    .map { _ in
                        LearnMainEvent.refresh
                    }
                    .eraseToAnyPublisher(),
                dependencies
                    .appEventsClient
                    .subscribe(for: FolderEvent.self)
                    .map { _ in
                        LearnMainEvent.refresh
                    }
                    .eraseToAnyPublisher(),
                dependencies
                    .appEventsClient
                    .subscribe(for: RememberItemEvent.self)
                    .map { _ in
                        LearnMainEvent.refresh
                    }
                    .eraseToAnyPublisher()
            ).eraseToAnyPublisher()
        }
    }
}

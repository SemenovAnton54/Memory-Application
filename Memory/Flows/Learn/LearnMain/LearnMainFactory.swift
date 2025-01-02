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
        let store = DefaultMemorizeStore(
            initialState: LearnMainState(fetchFavoriteFoldersRequest: FeedbackRequest()),
            reduce: LearnMainReducer().reduce,
            present: LearnMainPresenter().present,
            feedback: [
                makeRoutingLoop(router: router),
                makeFetchFavoriteFoldersRequestLoop(),
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
    func makeFetchFavoriteFoldersRequestLoop() -> LearnMainFeedbackLoop {
        react(request: \.fetchFavoriteFoldersRequest) { request in
            do {
                let model = try await dependencies.foldersService.fetchFolders(filters: FolderFilters(isFavorite: true))

                return .favoriteFoldersFetched(.success(model))
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
                    .eraseToAnyPublisher()
            ).eraseToAnyPublisher()
        }
    }
}

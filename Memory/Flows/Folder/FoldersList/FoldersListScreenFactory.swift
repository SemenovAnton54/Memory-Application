//
//  FoldersListScreenFactory.swift
//  Memory
//

struct FoldersListScreenFactory {
    struct Dependencies {
        let foldersService: FoldersServiceProtocol
        let appEventsClient: AppEventsClientProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        router: FoldersListRouterProtocol
    ) -> DefaultMemorizeStore<FoldersListState, FoldersListEvent, FoldersListViewState> {
        let store = DefaultMemorizeStore(
            initialState: FoldersListState(),
            reduce: FoldersListReducer().reduce,
            present: FoldersListPresenter().present,
            feedback: [
                makeFetchFolderRequestLoop(),
                makeFoldersEventsLoop(),
                makeRoutingLoop(router: router),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias FoldersListFeedbackLoop = FeedbackLoop<FoldersListState, FoldersListEvent>

extension FoldersListScreenFactory {
    func makeFetchFolderRequestLoop() -> FoldersListFeedbackLoop {
        react(request: \.fetchFoldersRequest) { request in
            do {
                let models = try await dependencies.foldersService.fetchFolders()

                return .foldersFetched(.success(models))
            } catch {
                return .foldersFetched(.failure(error))
            }
        }
    }

    func makeFoldersEventsLoop() -> FoldersListFeedbackLoop {
        feedbackLoop { _ in
            dependencies
                .appEventsClient
                .subscribe(for: FolderEvent.self)
                .map { _ in
                    .folderChanged
                }
                .eraseToAnyPublisher()
        }
    }
}

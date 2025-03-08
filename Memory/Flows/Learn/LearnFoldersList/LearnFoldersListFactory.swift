//
//  LearnFoldersListFactory.swift
//  Memory
//

import SwiftUI

struct LearnFoldersListFactory {
    struct Dependencies {
        let foldersService: FoldersServiceProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        router: LearnFoldersListRouterProtocol
    ) -> DefaultStateMachine<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState> {
        let store = DefaultStateMachine(
            initialState: LearnFoldersListState(),
            reduce: LearnFoldersListReducer().reduce,
            present: LearnFoldersListPresenter().present,
            feedback: [
                makeFetchFolderRequestLoop(),
                makeRoutingLoop(router: router),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias LearnFoldersListFeedbackLoop = FeedbackLoop<LearnFoldersListState, LearnFoldersListEvent>

extension LearnFoldersListFactory {
    func makeFetchFolderRequestLoop() -> LearnFoldersListFeedbackLoop {
        react(request: \.fetchFoldersRequest) { request in
            do {
                let models = try await dependencies.foldersService.fetchFolders()

                return .foldersFetched(.success(models))
            } catch {
                return .foldersFetched(.failure(error))
            }
        }
    }
}

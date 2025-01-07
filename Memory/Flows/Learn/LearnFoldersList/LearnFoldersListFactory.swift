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
    ) -> DefaultMemorizeStore<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState> {
        let store = DefaultMemorizeStore(
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

    @MainActor
    static func makeView(for store: DefaultMemorizeStore<LearnFoldersListState, LearnFoldersListEvent, LearnFoldersListViewState>) -> some View {
        LearnFoldersListView(store: store)
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

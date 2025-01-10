//
//  FolderDetailsFactory.swift
//  Memory
//

struct FolderDetailsFactory {
    typealias FolderRequest = FolderDetailsState.FolderRequest
    typealias CategoriesRequest = FolderDetailsState.CategoriesRequest

    struct Dependencies {
        let foldersService: FoldersServiceProtocol
        let categoriesService: CategoriesServiceProtocol
        let appEventsClient: AppEventsClientProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        id: Int,
        router: FolderDetailsRouterProtocol
    ) -> DefaultStateMachine<FolderDetailsState, FolderDetailsEvent, FolderDetailsViewState> {
        let store = DefaultStateMachine(
            initialState: FolderDetailsState(
                id: id,
                fetchFolderRequest: FeedbackRequest(FolderRequest(id: id)),
                fetchCategoriesRequest: FeedbackRequest(CategoriesRequest(folderId: id))
            ),
            reduce: FolderDetailsReducer().reduce,
            present: FolderDetailsPresenter().present,
            feedback: [
                makeFetchFolderRequestLoop(),
                makeDeleteFolderRequestLoop(),
                makeFetchCategoriesRequestLoop(),
                makeCategoryEventsLoop(),
                makeRoutingLoop(router: router),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias FolderDetailsFeedbackLoop = FeedbackLoop<FolderDetailsState, FolderDetailsEvent>

extension FolderDetailsFactory {
    func makeFetchFolderRequestLoop() -> FolderDetailsFeedbackLoop {
        react(request: \.fetchFolderRequest) { request in
            do {
                let model = try await dependencies.foldersService.fetchFolder(id: request.id)

                return .folderFetched(.success(model))
            } catch {
                return .folderFetched(.failure(error))
            }
        }
    }

    func makeDeleteFolderRequestLoop() -> FolderDetailsFeedbackLoop {
        react(request: \.deleteFolderRequest) { request in
            do {
                let model = try await dependencies.foldersService.remove(id: request.id)

                return .folderDeleted(.success(model))
            } catch {
                return .folderDeleted(.failure(error))
            }
        }
    }

    func makeCategoryEventsLoop() -> FolderDetailsFeedbackLoop {
        feedbackLoop { _ in
            dependencies
                .appEventsClient
                .subscribe(for: CategoryEvent.self)
                .map { _ in
                    .categoriesChanged
                }
                .eraseToAnyPublisher()
        }
    }

    func makeFetchCategoriesRequestLoop() -> FolderDetailsFeedbackLoop {
        react(request: \.fetchCategoriesRequest) { request in
            do {
                let models = try await dependencies.categoriesService.fetchCategories(for: request.folderId)

                return .categoriesFetched(.success(models))
            } catch {
                return .categoriesFetched(.failure(error))
            }
        }
    }
}

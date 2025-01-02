//
//  CategoryDetailsFactory.swift
//  Memory
//

struct CategoryDetailsFactory {
    typealias CategoryRequest = CategoryDetailsState.CategoryRequest
    typealias RememberItemsRequest = CategoryDetailsState.RememberItemsRequest

    struct Arguments {
        let id: Int
    }

    struct Dependencies {
        let categoriesService: CategoriesServiceProtocol
        let rememberItemsService: RememberItemsServiceProtocol
        let appEventsClient: AppEventsClientProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        arguments: Arguments,
        router: CategoryDetailsRouterProtocol
    ) -> DefaultMemorizeStore<CategoryDetailsState, CategoryDetailsEvent, CategoryDetailsViewState> {
        let store = DefaultMemorizeStore(
            initialState: CategoryDetailsState(
                id: arguments.id,
                categoryRequest: FeedbackRequest(CategoryRequest(id: arguments.id)),
                rememberItemsRequest: FeedbackRequest(RememberItemsRequest(categoryId: arguments.id))
            ),
            reduce: CategoryDetailsReducer().reduce,
            present: CategoryDetailsPresenter().present,
            feedback: [
                makeFetchCategoryRequestLoop(),
                makeRememberItemEventsLoop(),
                makeCategoryEventsLoop(),
                makeFetchRememberItemsRequestLoop(),
                makeDeleteRememberItemRequestLoop(),
                makeDeleteCategoryRequestLoop(),
                makeRoutingLoop(router: router),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias CategoryDetailsFeedbackLoop = FeedbackLoop<CategoryDetailsState, CategoryDetailsEvent>

extension CategoryDetailsFactory {
    func makeFetchCategoryRequestLoop() -> CategoryDetailsFeedbackLoop {
        react(request: \.categoryRequest) { request in
            do {
                let model = try await dependencies.categoriesService.fetchCategory(id: request.id)

                return .categoryFetched(.success(model))
            } catch {
                return .categoryFetched(.failure(error))
            }
        }
    }

    func makeDeleteCategoryRequestLoop() -> CategoryDetailsFeedbackLoop {
        react(request: \.deleteCategoryRequest) { request in
            do {
                let model = try await dependencies.categoriesService.remove(id: request.id)

                return .categoryDeleted(.success(model))
            } catch {
                return .categoryDeleted(.failure(error))
            }
        }
    }

    func makeDeleteRememberItemRequestLoop() -> CategoryDetailsFeedbackLoop {
        react(request: \.deleteRememberItemRequest) { request in
            do {
                let model = try await dependencies.rememberItemsService.remove(id: request.id)

                return .rememberItemDeleted(.success(model))
            } catch {
                return .rememberItemDeleted(.failure(error))
            }
        }
    }

    func makeCategoryEventsLoop() -> CategoryDetailsFeedbackLoop {
        feedbackLoop { _ in
            dependencies
                .appEventsClient
                .subscribe(for: CategoryEvent.self)
                .filter {
                    guard case .categoryUpdated = $0 else {
                        return false
                    }
                    
                    return true
                }
                .map { _ in
                    .categoryChanged
                }
                .eraseToAnyPublisher()
        }
    }

    func makeRememberItemEventsLoop() -> CategoryDetailsFeedbackLoop {
        feedbackLoop { _ in
            dependencies
                .appEventsClient
                .subscribe(for: RememberItemEvent.self)
                .map { _ in
                    .categoryChanged
                }
                .eraseToAnyPublisher()
        }
    }

    func makeFetchRememberItemsRequestLoop() -> CategoryDetailsFeedbackLoop {
        react(request: \.rememberItemsRequest) { request in
            do {
                let models = try await dependencies.rememberItemsService.fetchItems(for: request.categoryId)

                return .rememberItemsFetched(.success(models))
            } catch {
                return .rememberItemsFetched(.failure(error))
            }
        }
    }
}

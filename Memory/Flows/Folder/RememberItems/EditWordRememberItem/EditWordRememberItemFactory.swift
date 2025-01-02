//
//  EditWordRememberItemFactory.swift
//  Memory
//

import Foundation

struct EditWordRememberItemFactory {
    typealias RememberItemRequest = EditWordRememberItemState.RememberItemRequest

    enum EditWordRememberItemError: Error {
        case imageNotFound
    }

    struct Arguments {
        let id: Int?
        let categoriesIds: [Int]?
    }

    struct Dependencies {
        let rememberItemsService: RememberItemsServiceProtocol
    }

    let dependencies: Dependencies

    func makeStore(
        arguments: Arguments,
        router: EditWordRememberItemRouterProtocol
    ) -> DefaultMemorizeStore<EditWordRememberItemState, EditWordRememberItemEvent, EditWordRememberItemViewState> {
        var request: FeedbackRequest<RememberItemRequest>?

        if let id = arguments.id {
            request = FeedbackRequest(RememberItemRequest(id: id))
        }

        let store = DefaultMemorizeStore(
            initialState: EditWordRememberItemState(
                categoriesIds: arguments.categoriesIds ?? [],
                fetchRequest: request
            ),
            reduce: EditWordRememberItemReducer().reduce,
            present: EditWordRememberItemPresenter().present,
            feedback: [
                makeRoutingLoop(router: router),
                makeLoadImageRequestLoop(),
                makeCreateRememberItemRequestLoop(),
                makeUpdateRememberItemRequestLoop(),
                makeFetchRememberItemRequest(),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias EditWordRememberItemFeedbackLoop = FeedbackLoop<EditWordRememberItemState, EditWordRememberItemEvent>

extension EditWordRememberItemFactory {
    func makeLoadImageRequestLoop() -> EditWordRememberItemFeedbackLoop {
        react(request: \.loadImageRequest) { request in
            do {
                guard let data = try await request.loadImageRequest.loadTransferable(type: Data.self) else {
                    return .imageLoaded(.failure(EditWordRememberItemError.imageNotFound))
                }
                
                return .imageLoaded(.success(data))
            } catch {
                return .imageLoaded(.failure(error))
            }
        }
    }

    func makeFetchRememberItemRequest() -> EditWordRememberItemFeedbackLoop {
        react(request: \.fetchRequest) { request in
            do {
                let model = try await dependencies.rememberItemsService.fetchItem(id: request.id)

                return .itemFetched(.success(model))
            } catch {
                return .itemFetched(.failure(error))
            }
        }
    }

    func makeCreateRememberItemRequestLoop() -> EditWordRememberItemFeedbackLoop {
        react(request: \.createRequest) { newRememberItem in
            do {
                let model = try await dependencies.rememberItemsService.createItem(newItem: newRememberItem)

                return .itemCreated(.success(model))
            } catch {
                return .itemCreated(.failure(error))
            }
        }
    }

    func makeUpdateRememberItemRequestLoop() -> EditWordRememberItemFeedbackLoop {
        react(request: \.updateRequest) { rememberItem in
            do {
                let model = try await dependencies.rememberItemsService.updateItem(item: rememberItem)

                return .itemUpdated(.success(model))
            } catch {
                return .itemUpdated(.failure(error))
            }
        }
    }
}

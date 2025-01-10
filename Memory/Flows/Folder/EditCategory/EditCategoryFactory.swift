//
//  EditCategoryFactory.swift
//  Memory
//

import Combine
import PhotosUI
import Photos

struct EditCategoryFactory {
    enum EditCategoryError: Error {
        case imageNotFound
    }

    struct Dependencies {
        let categoriesService: CategoriesServiceProtocol
    }

    struct Arguments {
        let id: Int?
        let folderId: Int?
    }

    let dependencies: Dependencies

    func makeStore(
        arguments: Arguments,
        router: EditCategoryRouterProtocol
    ) -> DefaultStateMachine<EditCategoryState, EditCategoryEvent, EditCategoryViewState> {
        var fetchCategoryRequest: FeedbackRequest<Int>?

        if let id = arguments.id {
            fetchCategoryRequest = FeedbackRequest(id)
        }

        let store = DefaultStateMachine(
            initialState: EditCategoryState(
                folderId: arguments.folderId,
                id: arguments.id,
                fetchCategoryRequest: fetchCategoryRequest
            ),
            reduce: EditCategoryReducer().reduce,
            present: EditCategoryPresenter().present,
            feedback: [
                makeLoadImageRequestLoop(),
                makeCreateNewCategoryRequestLoop(),
                makeUpdateCategoryRequestLoop(),
                makeLoadCategoryRequestLoop(),
                makeRoutingLoop(router: router),
            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias EditCategoryFeedbackLoop = FeedbackLoop<EditCategoryState, EditCategoryEvent>

extension EditCategoryFactory {
    func makeLoadImageRequestLoop() -> EditCategoryFeedbackLoop {
        react(request: \.loadImageRequest) { request in
            do {
                guard let data = try await request.loadTransferable(type: Data.self) else {
                    return .imageLoaded(.failure(EditCategoryError.imageNotFound))
                }

                return .imageLoaded(.success(data))
            } catch {
                return .imageLoaded(.failure(error))
            }
        }
    }

    func makeCreateNewCategoryRequestLoop() -> EditCategoryFeedbackLoop {
        react(request: \.createNewCategoryRequest) { newCategory in
            do {
                let model = try await dependencies.categoriesService.createCategory(newCategory: newCategory)

                return .categoryCreated(.success(model))
            } catch {
                return .categoryCreated(.failure(error))
            }
        }
    }

    func makeUpdateCategoryRequestLoop() -> EditCategoryFeedbackLoop {
        react(request: \.updateCategoryRequest) { category in
            do {
                let model = try await dependencies.categoriesService.updateCategory(category: category)

                return .categoryUpdated(.success(model))
            } catch {
                return .categoryUpdated(.failure(error))
            }
        }
    }

    func makeLoadCategoryRequestLoop() -> EditCategoryFeedbackLoop {
        react(request: \.fetchCategoryRequest) { id in
            do {
                let model = try await dependencies.categoriesService.fetchCategory(id: id)

                return .categoryFetched(.success(model))
            } catch {
                return .categoryFetched(.failure(error))
            }
        }
    }
}

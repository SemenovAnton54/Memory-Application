//
//  ImagePickerFactory.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import Foundation
import SwiftUI

struct ImagePickerFactory {
    enum ImagePickerError: Error {
        case emptyData
    }

    struct Dependencies {
        let imagePickerService: ImagePickerServiceProtocol
    }

    struct Arguments {
        let text: String?
        let onComplete: ([ImageType]) -> ()
    }

    let dependencies: Dependencies

    func makeStore(
        arguments: Arguments,
        router: ImagePickerRouterProtocol
    ) -> DefaultStateMachine<ImagePickerState, ImagePickerEvent, ImagePickerViewState> {
        var request: FeedbackRequest<ImagePickerState.ImagesRequest>?

        if let text = arguments.text, !text.isEmpty {
            request = FeedbackRequest(ImagePickerState.ImagesRequest(text: text))
        }

        let store = DefaultStateMachine(
            initialState: ImagePickerState(
                text: arguments.text,
                fetchImagesRequest: request
            ),
            reduce: ImagePickerReducer().reduce,
            present: ImagePickerPresenter().present,
            feedback: [
                makeRoutingLoop(router: router),
                makeFetchImagesRequestLoop(),
                makeLoadImageRequestLoop(),
                makeSelectImagesRequestLoop(onSelect: arguments.onComplete),
            ]
        )

        return store
    }

    @MainActor
    static func makeView(for store: DefaultStateMachine<ImagePickerState, ImagePickerEvent, ImagePickerViewState>) -> some View {
        ImagePickerView(store: store)
    }
}

// MARK: - Feedback loops

typealias ImagePickerFeedbackLoop = FeedbackLoop<ImagePickerState, ImagePickerEvent>

extension ImagePickerFactory {
    func makeFetchImagesRequestLoop() -> ImagePickerFeedbackLoop {
        react(request: \.fetchImagesRequest) { request in
            do {
                let images = try await dependencies.imagePickerService.fetchImages(by: request.text)

                return .imagesFetched(.success(images))
            } catch {
                return .imagesFetched(.failure(error))
            }
        }
    }

    func makeLoadImageRequestLoop() -> ImagePickerFeedbackLoop {
        react(request: \.loadImageRequest) { request in
            do {
                guard let data = try await request.loadTransferable(type: Data.self) else {
                    return .imageLoaded(.failure(ImagePickerError.emptyData))
                }

                return .imageLoaded(.success(data))
            } catch {
                return .imageLoaded(.failure(error))
            }
        }
    }

    func makeSelectImagesRequestLoop(onSelect: @escaping ([ImageType]) -> ()) -> ImagePickerFeedbackLoop {
        react(request: \.selectImagesRequest) { request in
            onSelect(request)
            return .imagesSelected
        }
    }
}

//
//  ImagePickerReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 28.02.2025.
//

import Quick
import Nimble
import Foundation
import SwiftUI
import PhotosUI

@testable import Memory

final class ImagePickerReducerTests: QuickSpec {
    override class func spec() {
        describe("ImagePickReducer tests") {
            var reducer: ImagePickerReducer!
            var state: ImagePickerState!
            var router: ImagePickerRouterMock!

            beforeEach {
                reducer = ImagePickerReducer()
                state = ImagePickerState()
                router = ImagePickerRouterMock()
            }

            context("close event was sent") {
                beforeEach {
                    reducer.reduce(state: &state, event: .close)
                    performRouterRequest(from: state, to: router)
                }

                it("close was requested") {
                    expect(router.didClose) == true
                }
            }

            context("imagesFetched event was sent with success") {
                let images: [ImageModel] = [
                    .init(id: 1, imageType: .systemName("one")),
                    .init(id: 2, imageType: .systemName("two"))
                ]

                beforeEach {
                    state.fetchImagesRequest = FeedbackRequest(.init(text: "Pillow"))
                    reducer.reduce(
                        state: &state,
                        event: .imagesFetched(.success(images))
                    )
                }

                it("fetch images request empty") {
                    expect(state.fetchImagesRequest) == nil
                }

                it("images not empty") {
                    expect(state.images.map(\.id).toSet()) == images.map((\.id)).toSet()
                    expect(state.images.map(\.imageType).toSet()) == images.map((\.imageType)).toSet()
                }
            }

            context("imagesFetched event was sent with failure") {
                beforeEach {
                    state.fetchImagesRequest = FeedbackRequest(.init(text: "Pillow"))
                    reducer.reduce(state: &state, event: .imagesFetched(.failure(MockError.mockError)))
                }

                it("fetch images request empty") {
                    expect(state.fetchImagesRequest) == nil
                }
            }

            context("imageLoaded event was sent with success") {
                let imageData = Data()

                beforeEach {
                    state.loadImageRequest = FeedbackRequest(PhotosPickerItem(itemIdentifier: "test"))
                    reducer.reduce(
                        state: &state,
                        event: .imageLoaded(.success(imageData))
                    )
                }

                it("load images request empty") {
                    expect(state.loadImageRequest) == nil
                }

                it("imagesFromGallery not empty") {
                    expect(state.imagesFromGallery.first?.id) == 1
                    expect(state.imagesFromGallery.first?.imageType) == .data(imageData)
                }
            }

            context("imageLoaded event was sent with failure") {
                beforeEach {
                    state.loadImageRequest = FeedbackRequest(PhotosPickerItem(itemIdentifier: "test"))
                    reducer.reduce(
                        state: &state,
                        event: .imageLoaded(.failure(MockError.mockError))
                    )
                }

                it("load images request empty") {
                    expect(state.loadImageRequest) == nil
                }
            }

            context("imageLoaded event was sent with success and items before exists") {
                let imageData = Data()

                beforeEach {
                    state.imagesFromGallery = [.init(id: 1, imageType: .data(Data()))]
                    state.loadImageRequest = FeedbackRequest(PhotosPickerItem(itemIdentifier: "test"))
                    reducer.reduce(
                        state: &state,
                        event: .imageLoaded(.success(imageData))
                    )
                }

                it("load images request empty") {
                    expect(state.loadImageRequest) == nil
                }

                it("imagesFromGallery not empty") {
                    expect(state.imagesFromGallery.last?.id) == 2
                    expect(state.imagesFromGallery.last?.imageType) == .data(imageData)
                }
            }

            context("addImagesFromGallery event was sent create request") {
                let pickerItem = PhotosPickerItem(itemIdentifier: "test")

                beforeEach {
                    reducer.reduce(
                        state: &state,
                        event: .addImagesFromGallery(pickerItem)
                    )
                }

                it("load images request not empty") {
                    expect(state.loadImageRequest) != nil
                }
            }

            context("addImagesFromGallery event was sent but nil, create request") {
                beforeEach {
                    reducer.reduce(
                        state: &state,
                        event: .addImagesFromGallery(nil)
                    )
                }

                it("load images request empty") {
                    expect(state.loadImageRequest) == nil
                }
            }

            context("select event was sent create loadImageRequest") {
                let data = Data()
                beforeEach {
                    state.imagesFromGallery = [.init(id: 1, imageType: .data(data))]
                    state.images = [
                        .init(id: 3, imageType: .systemName("three")),
                        .init(id: 2, imageType: .systemName("two"))
                    ]
                    state.selectedImagesIds = [2]
                    reducer.reduce(
                        state: &state,
                        event: .select
                    )
                }

                it("selectImagesRequest created") {
                    expect(state.selectImagesRequest?.payload) == [.data(data), .systemName("two")]
                }
            }

            context("toggleImageSelection event was sent toggle selected image id") {
                beforeEach {
                    state.selectedImagesIds = [2]
                }

                it("image selected") {
                    expect(state.selectedImagesIds).toNot(contain(1))
                    reducer.reduce(
                        state: &state,
                        event: .toggleImageSelection(id: 1)
                    )
                    expect(state.selectedImagesIds).to(contain(1))
                }

                it("image disSelected") {
                    expect(state.selectedImagesIds).to(contain(2))
                    reducer.reduce(
                        state: &state,
                        event: .toggleImageSelection(id: 2)
                    )
                    expect(state.selectedImagesIds).toNot(contain(2))
                }
            }

            context("onRemoveImageFromGallery event was sent remove image with id") {
                let id = 1
                beforeEach {
                    state.imagesFromGallery = [.init(id: id, imageType: .data(Data()))]
                }

                it("image deleted") {
                    expect(state.imagesFromGallery.count) == 1
                    reducer.reduce(
                        state: &state,
                        event: .removeImageFromGallery(id: id)
                    )
                    expect(state.imagesFromGallery.count) == 0
                }
            }

            context("searchImages event was sent save text and create searchRequest") {
                let text = "some text"

                beforeEach {
                    state.text = "old text"
                }

                it("text entered") {
                    expect(state.text) != text
                    expect(state.fetchImagesRequest) == nil

                    reducer.reduce(
                        state: &state,
                        event: .searchImages(text)
                    )

                    expect(state.text) == text
                    expect(state.fetchImagesRequest) != nil
                }
            }

            context("imagesSelected event was sent. clear request and close") {
                beforeEach {
                    state.selectImagesRequest = FeedbackRequest([])
                }

                it("text entered") {
                    expect(state.selectImagesRequest) != nil

                    reducer.reduce(
                        state: &state,
                        event: .imagesSelected
                    )

                    performRouterRequest(from: state, to: router)

                    expect(state.selectImagesRequest) == nil
                    expect(router.didClose) == true
                }
            }
        }
    }
}

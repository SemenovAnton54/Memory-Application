//
//  EditCategoryReducerTests.swift
//  Memory
//

import Testing
import SwiftUI
import PhotosUI

@testable import Memory

@Suite
final class EditCategoryReducerTests {
    let reducer = EditCategoryReducer()

    var state = EditCategoryState()

    var router = EditCategoryRouterMock()

    @Test("Test nameDidChange event", arguments: ["New name", "Another name"])
    func testSendEventNameDidChangeOutputStateNameArgumentChanged(name: String) {
        #expect(state.name == "")

        reducer.reduce(state: &state, event: .nameDidChange(name))
        #expect(state.name == name)
    }

    @Test("Test descDidChanged event", arguments: ["Description one", "Another Description"])
    func testSendEventDescDidChangeOutputStateDescriptionArgumentChanged(description: String) {
        #expect(state.description == "")

        reducer.reduce(state: &state, event: .descDidChanged(description))
        #expect(state.description == description)
    }

    @Test("Test iconDidChanged event", arguments: ["😂", "🙂"])
    func testSendEventIconDidChangeOutputStateIconArgumentChanged(icon: String) {
        #expect(state.icon == "")

        reducer.reduce(state: &state, event: .iconDidChanged(icon))
        #expect(state.icon == icon)
    }

    @Test("Test iconDidChanged event state not changed", arguments: ["123", "t"])
    func testSendEventIconDidChangeOutputStateIconArgumentNotChanged(icon: String) {
        #expect(state.icon == "")

        reducer.reduce(state: &state, event: .iconDidChanged(icon))
        #expect(state.icon != icon)
    }

    @Test("Test addImage event", arguments: [PhotosPickerItem(itemIdentifier: "itemIdentifier"), PhotosPickerItem(itemIdentifier: "itemIdentifier two")])
    func testSendEventAddImageOutputStateLoadImageRequestArgumentChanged(value: PhotosPickerItem) {
        #expect(state.loadImageRequest == nil)

        reducer.reduce(state: &state, event: .addImage(value))
        #expect(state.loadImageRequest != nil)
    }

    @Test("Test addImage event", arguments: [nil])
    func testSendEventAddImageOutputStateLoadImageRequestArgumentNotChanged(value: PhotosPickerItem?) {
        #expect(state.loadImageRequest == nil)

        reducer.reduce(state: &state, event: .addImage(value))
        #expect(state.loadImageRequest == nil)
    }

    @Test("Test removeImage event")
    func testSendEventRemoveImageOutputStateImageArgumentChanged() {
        state.image = .systemName("MockImage")
        #expect(state.image != nil)

        reducer.reduce(state: &state, event: .removeImage)
        #expect(state.image == nil)
    }

    @Test("Test imageLoaded event")
    func testSendEventImageLoadedOutputStateImageArgumentChanged() {
        #expect(state.image == nil)

        reducer.reduce(state: &state, event: .imageLoaded(.success(Data())))
        #expect(state.image != nil)
    }

    @Test("Test imageLoaded event")
    func testSendEventImageLoadedOutputStateImageArgumentNotChanged() {
        #expect(state.image == nil)

        reducer.reduce(state: &state, event: .imageLoaded(.failure(MockError.mockError)))
        #expect(state.image == nil)
    }

    @Test("Test categoryFetched event success result")
    func testSendEventFolderFetchedOutputStateFolderArgumentsChanged() {
        let id = 1
        let folderId = 2
        state.id = id
        state.fetchCategoryRequest = FeedbackRequest(id)

        #expect(state.id == id)
        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.image == nil)
        #expect(state.folderId == nil)

        let category = MockCategoryModel.mockCategory(id: id, folderId: folderId)

        reducer.reduce(state: &state, event: .categoryFetched(.success(category)))

        #expect(state.id == id)
        #expect(state.name == category.name)
        #expect(state.description == category.desc)
        #expect(state.icon == category.icon)
        #expect(state.image == category.image)
        #expect(state.folderId == category.folderId)
        #expect(state.fetchCategoryRequest == nil)
    }

    @Test("Test categoryFetched event failure result")
    func testSendEventFolderFetchedOutputStateFolderArgumentsNotChanged() {
        let id = 1
        state.fetchCategoryRequest = FeedbackRequest(id)

        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.image == nil)
        #expect(state.fetchCategoryRequest != nil)

        reducer.reduce(state: &state, event: .categoryFetched(.failure(MockError.mockError)))

        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.image == nil)
        #expect(state.folderId == nil)
        #expect(state.fetchCategoryRequest == nil)
    }

    @Test("Test categoryCreated event success result")
    func testSendEventFolderCreatedOutputStateFolderArgumentsChanged() {
        #expect(state.id == nil)
        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.image == nil)
        #expect(state.folderId == nil)

        let id = 1
        let mockNewModel = MockCategoryModel.mockNewCategoryModel()

        state.createNewCategoryRequest = FeedbackRequest(mockNewModel)

        let category = MockCategoryModel.mockCategory(id: id)
        reducer.reduce(state: &state, event: .categoryCreated(.success(category)))

        #expect(state.id == id)
        #expect(state.createNewCategoryRequest == nil)
        #expect(state.name == category.name)
        #expect(state.description == category.desc)
        #expect(state.icon == category.icon)
        #expect(state.image == category.image)
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose == true)
    }

    @Test("Test categoryUpdated event success result")
    func testSendEventFolderUpdatedOutputStateFolderArgumentsChanged() {
        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.image == nil)
        #expect(state.folderId == nil)

        let id = 1
        let mockUpdateModel = MockCategoryModel.mockUpdateCategoryModel(id: id)

        state.updateCategoryRequest = FeedbackRequest(mockUpdateModel)

        let category = MockCategoryModel.mockCategory(id: id)
        reducer.reduce(state: &state, event: .categoryUpdated(.success(category)))

        #expect(state.updateCategoryRequest == nil)
        #expect(state.name == category.name)
        #expect(state.description == category.desc)
        #expect(state.icon == category.icon)
        #expect(state.image == category.image)
        #expect(state.folderId == category.folderId)
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose == true)
    }

    @Test("Test cancel event")
    func testSendEventCancelOutputStateCloseRequestChanged() {
        reducer.reduce(state: &state, event: .cancel)
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose == true)
    }

    @Test("Test save event with id")
    func testSendEventSaveOutputStateUpdateRequestChanged() {
        state.id = 2
        state.folderId = 78
        state.name = "Test"
        state.description = "Test Description"
        state.icon = "😫"
        state.image = .systemName("mock image")

        #expect(state.updateCategoryRequest == nil)

        reducer.reduce(state: &state, event: .save)

        #expect(state.updateCategoryRequest != nil)
        #expect(state.updateCategoryRequest?.payload.id == state.id)
        #expect(state.updateCategoryRequest?.payload.folderId == state.folderId)
        #expect(state.updateCategoryRequest?.payload.name == state.name)
        #expect(state.updateCategoryRequest?.payload.desc == state.description)
        #expect(state.updateCategoryRequest?.payload.icon == state.icon)
        #expect(state.updateCategoryRequest?.payload.image == state.image)
    }

    @Test("Test save event with id but empty name not requested")
    func testSendEventSaveOutputStateUpdateRequestNotChanged() {
        state.id = 2
        state.folderId = 78
        state.name = ""
        state.description = "Test Description"
        state.icon = "😫"
        state.image = .systemName("mock image")

        #expect(state.updateCategoryRequest == nil)

        reducer.reduce(state: &state, event: .save)

        #expect(state.updateCategoryRequest == nil)
    }

    @Test("Test save event without id create new element")
    func testSendEventSaveOutputStateCreateRequestChanged() {
        state.folderId = 78
        state.name = "Test"
        state.description = "Test Description"
        state.icon = "😫"
        state.image = .systemName("mock image")

        #expect(state.createNewCategoryRequest == nil)

        reducer.reduce(state: &state, event: .save)

        #expect(state.createNewCategoryRequest != nil)
        #expect(state.createNewCategoryRequest?.payload.name == state.name)
        #expect(state.createNewCategoryRequest?.payload.desc == state.description)
        #expect(state.createNewCategoryRequest?.payload.icon == state.icon)
        #expect(state.createNewCategoryRequest?.payload.image == state.image)
        #expect(state.createNewCategoryRequest?.payload.folderId == state.folderId)
    }

    @Test("Test save event without id not create new element")
    func testSendEventSaveOutputStateCreateRequestNotChanged() {
        state.folderId = 78
        state.name = ""
        state.description = "Test Description"
        state.icon = "😫"
        state.image = .systemName("mock image")

        #expect(state.createNewCategoryRequest == nil)

        reducer.reduce(state: &state, event: .save)

        #expect(state.createNewCategoryRequest == nil)
    }
}

//
//  EditFolderReducerTests.swift
//  Memory
//

import Testing
import SwiftUI
import PhotosUI

@testable import Memory

@Suite
final class EditFolderReducerTests {
    let reducer = EditFolderReducer()

    var state = EditFolderState()

    var router = EditFolderRouterMock()

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

    @Test("Test isFavoriteChanged event", arguments: [true, false])
    func testSendEventIsFavoriteChangedOutputStateIsFavoriteArgumentChanged(value: Bool) {
        #expect(state.isFavorite == false)

        reducer.reduce(state: &state, event: .isFavoriteChanged(value))
        #expect(state.isFavorite == value)
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

    @Test("Test folderFetched event success result")
    func testSendEventFolderFetchedOutputStateFolderArgumentsChanged() {
        let id = 1
        state.id = id
        state.fetchFolderRequest = FeedbackRequest(id)

        #expect(state.id == id)
        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.isFavorite == false)
        #expect(state.image == nil)

        let folder = MockFolderModel.mockFolder()

        reducer.reduce(state: &state, event: .folderFetched(.success(folder)))

        #expect(state.id == id)
        #expect(state.name == folder.name)
        #expect(state.description == folder.desc)
        #expect(state.icon == folder.icon)
        #expect(state.isFavorite == folder.isFavorite)
        #expect(state.image == folder.image)
        #expect(state.fetchFolderRequest == nil)
    }

    @Test("Test folderFetched event failure result")
    func testSendEventFolderFetchedOutputStateFolderArgumentsNotChanged() {
        let id = 1
        state.fetchFolderRequest = FeedbackRequest(id)

        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.isFavorite == false)
        #expect(state.image == nil)
        #expect(state.fetchFolderRequest != nil)

        reducer.reduce(state: &state, event: .folderFetched(.failure(MockError.mockError)))

        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.isFavorite == false)
        #expect(state.image == nil)
        #expect(state.fetchFolderRequest == nil)
    }

    @Test("Test folderCreated event success result")
    func testSendEventFolderCreatedOutputStateFolderArgumentsChanged() {
        #expect(state.id == nil)
        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.isFavorite == false)
        #expect(state.image == nil)

        let id = 1
        let mockNewModel = MockFolderModel.mockNewFolderModel()

        state.createNewFolderRequest = FeedbackRequest(mockNewModel)

        let folder = MockFolderModel.mockFolder(id: id)
        reducer.reduce(state: &state, event: .folderCreated(.success(folder)))

        #expect(state.id == id)
        #expect(state.createNewFolderRequest == nil)
        #expect(state.name == folder.name)
        #expect(state.description == folder.desc)
        #expect(state.icon == folder.icon)
        #expect(state.isFavorite == folder.isFavorite)
        #expect(state.image == folder.image)
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose == true)
    }

    @Test("Test folderUpdated event success result")
    func testSendEventFolderUpdatedOutputStateFolderArgumentsChanged() {
        #expect(state.name == "")
        #expect(state.description == "")
        #expect(state.icon == "")
        #expect(state.isFavorite == false)
        #expect(state.image == nil)

        let id = 1
        let mockUpdateModel = MockFolderModel.mockUpdateFolderModel()

        state.updateFolderRequest = FeedbackRequest(mockUpdateModel)

        let folder = MockFolderModel.mockFolder(id: id)
        reducer.reduce(state: &state, event: .folderUpdated(.success(folder)))

        #expect(state.updateFolderRequest == nil)
        #expect(state.name == folder.name)
        #expect(state.description == folder.desc)
        #expect(state.icon == folder.icon)
        #expect(state.isFavorite == folder.isFavorite)
        #expect(state.image == folder.image)
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
        let id = 2
        state.id = id
        state.name = "Test"
        state.description = "Test Description"
        state.icon = "😫"
        state.isFavorite = true
        state.image = .systemName("mock image")

        #expect(state.updateFolderRequest == nil)

        reducer.reduce(state: &state, event: .save)

        #expect(state.updateFolderRequest != nil)
        #expect(state.updateFolderRequest?.payload.name == state.name)
        #expect(state.updateFolderRequest?.payload.desc == state.description)
        #expect(state.updateFolderRequest?.payload.icon == state.icon)
        #expect(state.updateFolderRequest?.payload.isFavorite == state.isFavorite)
        #expect(state.updateFolderRequest?.payload.image == state.image)
    }

    @Test("Test save event without id")
    func testSendEventSaveOutputStateCreateRequestChanged() {
        state.name = "Test"
        state.description = "Test Description"
        state.icon = "😫"
        state.isFavorite = true
        state.image = .systemName("mock image")

        #expect(state.createNewFolderRequest == nil)

        reducer.reduce(state: &state, event: .save)

        #expect(state.createNewFolderRequest != nil)
        #expect(state.createNewFolderRequest?.payload.name == state.name)
        #expect(state.createNewFolderRequest?.payload.desc == state.description)
        #expect(state.createNewFolderRequest?.payload.icon == state.icon)
        #expect(state.createNewFolderRequest?.payload.isFavorite == state.isFavorite)
        #expect(state.createNewFolderRequest?.payload.image == state.image)
    }
}

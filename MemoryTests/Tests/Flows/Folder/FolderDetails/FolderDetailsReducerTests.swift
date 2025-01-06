//
//  FolderDetailsReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 06.01.2025.
//

import Testing

@testable import Memory

@Suite
final class FolderDetailsReducerTests {
    private static var folderId = 1

    let reducer = FolderDetailsReducer()

    var state = FolderDetailsState(id: FolderDetailsReducerTests.folderId)

    var router = FolderDetailsRouterMock()

    @Test("Test deleteFolder event")
    func testSendEventDeleteFolderOutputStateDeleteFolderRequestChanged() {
        #expect(state.deleteFolderRequest == nil)

        reducer.reduce(state: &state, event: .deleteFolder)
        #expect(state.deleteFolderRequest?.payload.id == state.id)
    }

    @Test("Test folderDeleted event result success")
    func testSendEventFolderDeletedOutputStateDeleteFolderRequestChanged() {
        state.deleteFolderRequest = FeedbackRequest(.init(id: Self.folderId))
        let folder = MockFolderModel.mockFolder()

        reducer.reduce(state: &state, event: .folderDeleted(.success(folder)))

        #expect(state.deleteFolderRequest == nil)
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose == true)
    }

    @Test("Test folderDeleted event result failure")
    func testSendEventFolderDeletedOutputStateDeleteFolderRequestNotChanged() {
        state.deleteFolderRequest = FeedbackRequest(.init(id: Self.folderId))

        reducer.reduce(state: &state, event: .folderDeleted(.failure(MockError.mockError)))

        #expect(state.deleteFolderRequest == nil)
    }

    @Test("Test folderFetched event result success")
    func testSendEventFolderFetchedOutputStateFetchFolderRequestAndFolderChanged() {
        state.fetchFolderRequest = FeedbackRequest(.init(id: Self.folderId))
        let folder = MockFolderModel.mockFolder()

        reducer.reduce(state: &state, event: .folderFetched(.success(folder)))

        #expect(state.fetchFolderRequest == nil)
        #expect(state.folder?.id == folder.id)
    }

    @Test("Test folderFetched event result failure")
    func testSendEventFolderFetchedOutputStateFetchFolderRequestAndFolderNotChanged() {
        state.fetchFolderRequest = FeedbackRequest(.init(id: Self.folderId))

        reducer.reduce(state: &state, event: .folderFetched(.failure(MockError.mockError)))

        #expect(state.fetchFolderRequest == nil)
    }

    @Test("Test categoriesFetched event result success")
    func testSendEventCategoriesFetchedOutputStateFetchCategoriesRequestAndCategoriesChanged() {
        state.fetchCategoriesRequest = FeedbackRequest(.init(folderId: Self.folderId))
        let categories = [MockCategoryModel.mockCategory(id: 1), MockCategoryModel.mockCategory(id: 3)]

        reducer.reduce(state: &state, event: .categoriesFetched(.success(categories)))

        #expect(state.fetchCategoriesRequest == nil)
        #expect(state.categories.count == categories.count)
    }

    @Test("Test categoriesFetched event result failure")
    func testSendEventCategoriesFetchedOutputStateFetchCategoriesRequestAndCategoriesNotChanged() {
        state.fetchCategoriesRequest = FeedbackRequest(.init(folderId: Self.folderId))

        reducer.reduce(state: &state, event: .categoriesFetched(.failure(MockError.mockError)))

        #expect(state.fetchCategoriesRequest == nil)
        #expect(state.categories.isEmpty)
    }

    @Test("Test addCategory event")
    func testSendEventAddCategoryOutputStateRouterRequestChanged() {
        reducer.reduce(state: &state, event: .addCategory)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didNewCategoryWithFolderId == .triggered(Self.folderId))
    }

    @Test("Test editFolder event")
    func testSendEventEditFolderOutputStateRouterRequestChanged() {
        reducer.reduce(state: &state, event: .editFolder)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didEditFolderWithId == .triggered(Self.folderId))
    }

    @Test("Test categoriesChanged event")
    func testSendCategoriesChangedFolderOutputStateFetchCategoriesRequestChanged() {
        reducer.reduce(state: &state, event: .categoriesChanged)

        #expect(state.fetchCategoriesRequest?.payload.folderId == Self.folderId)
    }

    @Test("Test categoryDetails event")
    func testSendCategoryDetailsFolderOutputStateRouterRequestChanged() {
        let categoryId = 2
        reducer.reduce(state: &state, event: .categoryDetails(id: categoryId))

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didCategoryDetailsWithId == .triggered(categoryId))
    }
}

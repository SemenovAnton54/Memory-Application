//
//  FoldersListReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 06.01.2025.
//

import Testing

@testable import Memory

@Suite
final class FoldersListReducerTests {
    private static var categoryId = 1

    let reducer = FoldersListReducer()

    var state = FoldersListState()

    var router = FoldersListRouterMock()

    @Test("Test contentAppeared event")
    func testSendContentAppearedOutputStateFetchFoldersRequestChanged() {
        reducer.reduce(state: &state, event: .contentAppeared)

        #expect(state.fetchFoldersRequest != nil)
    }

    @Test("Test folderChanged event")
    func testSendFolderChangedOutputStateFetchFoldersRequestChanged() {
        reducer.reduce(state: &state, event: .folderChanged)

        #expect(state.fetchFoldersRequest != nil)
    }

    @Test("Test newFolder event")
    func testSendNewFolderOutputStateRouterRequestChanged() {
        reducer.reduce(state: &state, event: .newFolder)

        performRouterRequest(from: state, to: router)

        #expect(router.didNewFolder)
    }

    @Test("Test folderSelected event")
    func testSendFolderSelectedOutputStateRouterRequestChanged() {
        let id = 1
        reducer.reduce(state: &state, event: .folderSelected(id: id))

        performRouterRequest(from: state, to: router)

        #expect(router.didOpenFolderWithId == id)
    }

    @Test("Test foldersFetched event with success")
    func testSendFoldersFetchedOutputStateFetchFoldersRequestAndFoldersChanged() {
        let folders = [MockFolderModel.mockFolder(id: 1), MockFolderModel.mockFolder(id: 2)]
        state.fetchFoldersRequest = FeedbackRequest()

        reducer.reduce(state: &state, event: .foldersFetched(.success(folders)))

        #expect(state.fetchFoldersRequest == nil)
        #expect(state.folders.count == folders.count)
    }

    @Test("Test foldersFetched event with failure")
    func testSendFoldersFetchedOutputStateFetchFoldersRequestAndFoldersNotChanged() {
        state.fetchFoldersRequest = FeedbackRequest()

        reducer.reduce(state: &state, event: .foldersFetched(.failure(MockError.mockError)))

        #expect(state.fetchFoldersRequest == nil)
    }
}

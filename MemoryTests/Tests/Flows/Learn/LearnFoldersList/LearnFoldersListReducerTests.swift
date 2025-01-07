//
//  LearnFoldersListReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

import Testing

@testable import Memory

@Suite
final class LearnFoldersListReducerTests {
    let reducer = LearnFoldersListReducer()

    var state = LearnFoldersListState()

    var router = LearnFoldersListRouterMock()

    @Test("Test folderSelected event")
    func testSendEventFolderSelectedOutputStateRoutingRequestChanged() {
        let id = 1
        reducer.reduce(state: &state, event: .folderSelected(id: id))
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didLearnFolderWithId == id)
    }

    @Test("Test foldersFetched event")
    func testSendEventFoldersFetchedOutputStateFoldersChanged() {
        state.fetchFoldersRequest = FeedbackRequest()
        let folders = [MockFolderModel.mockFolder(id: 1), MockFolderModel.mockFolder(id: 2), MockFolderModel.mockFolder(id: 3)]
        reducer.reduce(state: &state, event: .foldersFetched(.success(folders)))

        #expect(state.fetchFoldersRequest == nil)

        #expect(state.folders.count == folders.count)
    }
}

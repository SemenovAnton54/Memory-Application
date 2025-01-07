//
//  LearnMainReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

import Testing

@testable import Memory

@Suite
final class LearnMainReducerTests {
    let reducer = LearnMainReducer()

    var state = LearnMainState()

    var router = LearnMainRouterMock()

    @Test("Test onAppear event")
    func testSendEventOnAppearOutputStateFoldersExistsRequestAndFetchFavoriteFoldersRequestChanged() {
        reducer.reduce(state: &state, event: .onAppear)

        #expect(state.foldersExistsRequest != nil)
        #expect(state.fetchFavoriteFoldersRequest != nil)
    }

    @Test("Test refresh event")
    func testSendEventRefreshOutputStateFoldersExistsRequestAndFetchFavoriteFoldersRequestChanged() {
        reducer.reduce(state: &state, event: .refresh)

        #expect(state.foldersExistsRequest != nil)
        #expect(state.fetchFavoriteFoldersRequest != nil)
    }

    @Test("Test refresh event")
    func testSendEventShowAllFoldersOutputStateRoutingRequestChanged() {
        reducer.reduce(state: &state, event: .showAllFolders)

        #expect(state.routingRequest != nil)
        performRouterRequest(from: state, to: router)
        #expect(router.didAllFolders)
    }

    @Test("Test folderSelected event")
    func testSendEventFolderSelectedOutputStateRoutingRequestChanged() {
        let folderId = 1
        reducer.reduce(state: &state, event: .folderSelected(id: folderId))

        #expect(state.routingRequest != nil)
        performRouterRequest(from: state, to: router)
        #expect(router.didSelectLearnModeWithId == folderId)
    }

    @Test("Test learnNewItems event")
    func testSendEventLearnNewItemsOutputStateRoutingRequestChanged() {
        let folderId = 1
        reducer.reduce(state: &state, event: .learnNewItems(folderId: folderId))

        #expect(state.routingRequest != nil)
        performRouterRequest(from: state, to: router)
        #expect(router.didLearnFolderWithId == folderId)
    }

    @Test("Test reviewItems event")
    func testSendEventReviewItemsOutputStateRoutingRequestChanged() {
        let folderId = 1
        reducer.reduce(state: &state, event: .reviewItems(folderId: folderId))

        #expect(state.routingRequest != nil)
        performRouterRequest(from: state, to: router)
        #expect(router.didReviewFolderWithId == folderId)
    }

    @Test("Test foldersExist event success result", arguments: [false, true])
    func testSendEventFoldersExistOutputStateFoldersExistsChanged(result: Bool) {
        reducer.reduce(state: &state, event: .foldersExist(.success(result)))

        #expect(state.foldersExists == result)
    }

    @Test("Test foldersExist event failure")
    func testSendEventFoldersExistOutputStateFoldersExistsNotChanged() {
        reducer.reduce(state: &state, event: .foldersExist(.failure(MockError.mockError)))

        #expect(!state.foldersExists)
    }


    @Test("Test favoriteFoldersFetched event success")
    func testSendEventFavoriteFoldersFetchedOutputStateFavoriteFoldersChanged() {
        let favoriteFolderModels: [LearnMainState.FavoriteFolderModel] = [
            .init(
                folder: MockFolderModel.mockFolder(id: 1),
                newCardsStatistics: .init(learnedCount: 1, toLearnCount: 1),
                reviewCardsStatistics: .init(learnedCount: 1, toLearnCount: 2)
            ),
            .init(
                folder: MockFolderModel.mockFolder(id: 2),
                newCardsStatistics: .init(learnedCount: 1, toLearnCount: 1),
                reviewCardsStatistics: .init(learnedCount: 1, toLearnCount: 2)
            )
        ]

        reducer.reduce(state: &state, event: .favoriteFoldersFetched(.success(favoriteFolderModels)))

        #expect(state.favoriteFolders.count == favoriteFolderModels.count)
    }
}

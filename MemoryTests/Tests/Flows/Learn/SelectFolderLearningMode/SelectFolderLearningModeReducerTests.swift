//
//  SelectFolderLearningModeReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

import Testing

@testable import Memory

@Suite
final class SelectFolderLearningModeReducerTests {
    static let folderId: Int = 1

    let reducer = SelectFolderLearningModeReducer()

    var state = SelectFolderLearningModeState(folderId: SelectFolderLearningModeReducerTests.folderId)

    var router = SelectFolderLearningModeRouterMock()

    @Test("Test learnNewCards event")
    func testSendEventLearnNewCardsOutputStateRoutingRequestChanged() {
        reducer.reduce(state: &state, event: .learnNewCards)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didLearnNewCardsWithFolderId == SelectFolderLearningModeReducerTests.folderId)
    }

    @Test("Test reviewCards event")
    func testSendEventReviewCardsOutputStateRoutingRequestChanged() {
        reducer.reduce(state: &state, event: .reviewCards)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didReviewCardsWithFolderId == SelectFolderLearningModeReducerTests.folderId)
    }

    @Test("Test newCardItemsStatisticsFetched event success result")
    func testSendEventNewCardItemsStatisticsFetchedOutputStateNewItemsStatisticsChanged() {
        let statisticsModel = LearnStatisticsModel(learnedCount: 1, toLearnCount: 2)
        state.fetchNewItemsStatisticsRequest = FeedbackRequest()

        reducer.reduce(state: &state, event: .newCardItemsStatisticsFetched(.success(statisticsModel)))

        #expect(state.fetchNewItemsStatisticsRequest == nil)
        #expect(state.newItemsStatistics?.learnedCount == statisticsModel.learnedCount)
        #expect(state.newItemsStatistics?.toLearnCount == statisticsModel.toLearnCount)
    }

    @Test("Test reviewCardItemsStatisticsFetched event failure result")
    func testSendEventReviewCardItemsStatisticsFetchedOutputFetchReviewItemsStatisticsRequestChanged() {
        let statisticsModel = LearnStatisticsModel(learnedCount: 1, toLearnCount: 2)
        state.fetchReviewItemsStatisticsRequest = FeedbackRequest()

        reducer.reduce(state: &state, event: .reviewCardItemsStatisticsFetched(.success(statisticsModel)))

        #expect(state.fetchNewItemsStatisticsRequest == nil)
        #expect(state.reviewItemsStatistics?.learnedCount == statisticsModel.learnedCount)
        #expect(state.reviewItemsStatistics?.toLearnCount == statisticsModel.toLearnCount)
    }
}

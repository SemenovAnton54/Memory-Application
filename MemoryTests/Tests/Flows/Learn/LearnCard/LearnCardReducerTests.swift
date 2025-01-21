//
//  LearnCardReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 08.01.2025.
//

import Testing

@testable import Memory

@Suite
final class LearnCardReducerTests {
    let rememberCardItemModel = MockRememberItemModel.mockRememberItemModel()

    let reducer = LearnCardReducer()

    var state = LearnCardState()

    var router = LearnCardRouterMock()

    @Test("Test remember event")
    func testSendEventRememberOutputStateCardItemRememberedRequestChanged() {
        state.rememberCardItemModel = rememberCardItemModel
        reducer.reduce(state: &state, event: .remember)

        #expect(state.cardItemRememberedRequest?.payload == rememberCardItemModel.id)
    }
    
    @Test("Test notRemember event")
    func testSendEventNotRememberOutputStateCardItemForgottenRequestChanged() {
        state.rememberCardItemModel = rememberCardItemModel
        reducer.reduce(state: &state, event: .notRemember)

        #expect(state.cardItemForgottenRequest?.payload == rememberCardItemModel.id)
    }
    
    @Test("Test editCard event")
    func testSendEventEditCardOutputStateRoutingRequestChanged() {
        state.rememberCardItemModel = rememberCardItemModel
        reducer.reduce(state: &state, event: .editCard)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didEditRememberItemWithId == rememberCardItemModel.id)
    }
    
    @Test("Test playingTextStarted event")
    func testSendEventPlayingTextStartedOutputStatePlayTextRequestChanged() {
        state.playTextRequest = FeedbackRequest("Test")
        reducer.reduce(state: &state, event: .playingTextStarted)

        #expect(state.playTextRequest == nil)
    }
    
    @Test("Test rememberItemUpdated event")
    func testSendEventRememberItemUpdatedOutputStateFetchUpdatedCardRequestChanged() {
        state.rememberCardItemModel = rememberCardItemModel

        reducer.reduce(state: &state, event: .rememberItemUpdated(id: rememberCardItemModel.id))
        #expect(state.fetchUpdatedCardRequest?.payload.id == rememberCardItemModel.id)

        state.fetchUpdatedCardRequest = nil
        reducer.reduce(state: &state, event: .rememberItemUpdated(id: rememberCardItemModel.id + 1))
        #expect(state.fetchUpdatedCardRequest == nil)


        state.cardItemForgottenRequest = FeedbackRequest(1)
        state.fetchUpdatedCardRequest = nil
        reducer.reduce(state: &state, event: .rememberItemUpdated(id: rememberCardItemModel.id))
        #expect(state.fetchUpdatedCardRequest == nil)


        state.cardItemForgottenRequest = nil
        state.fetchUpdatedCardRequest = nil
        state.cardItemRememberedRequest = FeedbackRequest(1)
        reducer.reduce(state: &state, event: .rememberItemUpdated(id: rememberCardItemModel.id))
        #expect(state.fetchUpdatedCardRequest == nil)


        state.cardItemForgottenRequest = nil
        state.fetchUpdatedCardRequest = nil
        state.cardItemRememberedRequest = nil
        state.nextCardRequest = FeedbackRequest(LearnCardState.NextCardRequest(previousId: nil))
        reducer.reduce(state: &state, event: .rememberItemUpdated(id: rememberCardItemModel.id))
        #expect(state.fetchUpdatedCardRequest == nil)
    }

    @Test("Test cardItemRepeatLevelChanged event success and failure result")
    func testSendEventCardItemRepeatLevelChangedOutputStateNextCardRequestChanged() {
        state.rememberCardItemModel = rememberCardItemModel
        state.cardItemRememberedRequest = FeedbackRequest(1)
        state.cardItemForgottenRequest = FeedbackRequest(1)

        reducer.reduce(state: &state, event: .cardItemRepeatLevelChanged(.success(rememberCardItemModel)))

        #expect(state.cardItemRememberedRequest == nil)
        #expect(state.cardItemForgottenRequest == nil)
        #expect(state.nextCardRequest != nil)

        state.rememberCardItemModel = rememberCardItemModel
        state.cardItemRememberedRequest = FeedbackRequest(1)
        state.cardItemForgottenRequest = FeedbackRequest(1)

        reducer.reduce(state: &state, event: .cardItemRepeatLevelChanged(.failure(MockError.mockError)))

        #expect(state.cardItemRememberedRequest == nil)
        #expect(state.cardItemForgottenRequest == nil)
        #expect(state.nextCardRequest != nil)
    }

    @Test("Test updatedCardItemFetched event success and failure result", arguments: ["word new", "word2", "word3" , "word4"])
    func testSendEventUpdatedCardItemFetchedOutputStateRememberCardItemModelChanged(word: String) {
        state.rememberCardItemModel = rememberCardItemModel
        state.fetchUpdatedCardRequest = FeedbackRequest(LearnCardState.CardRequest(id: rememberCardItemModel.id))

        let changedRememberCardItemModel = MockRememberItemModel.mockRememberItemModel(
            word: .init(
                id: 1,
                word: word,
                transcription: "description",
                translation: "translation",
                examples: [],
                images: []
            )
        )

        reducer.reduce(state: &state, event: .updatedCardItemFetched(.success(changedRememberCardItemModel)))

        #expect(state.fetchUpdatedCardRequest == nil)
        #expect(state.rememberCardItemModel?.word?.word == word)


        let changedRememberCardItemModelWithDifferentId = MockRememberItemModel.mockRememberItemModel(
            id: rememberCardItemModel.id + 1,
            word: .init(
                id: 1,
                word: word,
                transcription: "description",
                translation: "translation",
                examples: [],
                images: []
            )
        )
        state.rememberCardItemModel = rememberCardItemModel
        state.fetchUpdatedCardRequest = FeedbackRequest(LearnCardState.CardRequest(id: rememberCardItemModel.id))

        reducer.reduce(state: &state, event: .updatedCardItemFetched(.success(changedRememberCardItemModelWithDifferentId)))

        #expect(state.fetchUpdatedCardRequest == nil)
        #expect(state.rememberCardItemModel?.word?.word != word)
        #expect(state.rememberCardItemModel?.word?.word == rememberCardItemModel.word?.word)


        state.rememberCardItemModel = rememberCardItemModel
        state.fetchUpdatedCardRequest = FeedbackRequest(LearnCardState.CardRequest(id: rememberCardItemModel.id))

        reducer.reduce(state: &state, event: .updatedCardItemFetched(.failure(MockError.mockError)))

        #expect(state.fetchUpdatedCardRequest == nil)
    }

    @Test("Test nextCardItemFetched event success and failure result")
    func testSendEventNextCardItemFetchedOutputStateNextCardRequestChanged() {
        state.rememberCardItemModel = rememberCardItemModel
        state.nextCardRequest = FeedbackRequest(LearnCardState.NextCardRequest(previousId: nil))
        state.wordCardState = .init(
            actionStyle: .answer,
            enteringWord: "enteringWord",
            wrongAnswersCount: 1
        )

        let nextRememberCardItemModel = MockRememberItemModel.mockRememberItemModel(id: rememberCardItemModel.id + 1)

        reducer.reduce(state: &state, event: .nextCardItemFetched(.success(nextRememberCardItemModel)))
        
        #expect(state.nextCardRequest == nil)
        #expect(state.rememberCardItemModel?.id == nextRememberCardItemModel.id)
        #expect(state.wordCardState?.actionStyle == .buttons)
        #expect(state.wordCardState?.enteringWord == "")
        #expect(state.wordCardState?.wrongAnswersCount == 0)

        state.nextCardRequest = FeedbackRequest(LearnCardState.NextCardRequest(previousId: nil))
        state.rememberCardItemModel = rememberCardItemModel
        state.wordCardState = .init(
            actionStyle: .answer,
            enteringWord: "enteringWord",
            wrongAnswersCount: 1
        )

        reducer.reduce(state: &state, event: .nextCardItemFetched(.success(nil)))

        #expect(state.nextCardRequest == nil)
        #expect(state.rememberCardItemModel == nil)
        #expect(state.wordCardState?.actionStyle == .buttons)
        #expect(state.wordCardState?.enteringWord == "")
        #expect(state.wordCardState?.wrongAnswersCount == 0)

        state.rememberCardItemModel = rememberCardItemModel
        state.nextCardRequest = FeedbackRequest(LearnCardState.NextCardRequest(previousId: nil))
        state.wordCardState = .init(
            actionStyle: .answer,
            enteringWord: "enteringWord",
            wrongAnswersCount: 1
        )

        reducer.reduce(state: &state, event: .nextCardItemFetched(.failure(MockError.mockError)))
        #expect(state.nextCardRequest == nil)
    }
}

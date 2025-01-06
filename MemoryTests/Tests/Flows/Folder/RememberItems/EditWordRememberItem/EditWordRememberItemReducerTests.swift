//
//  EditWordRememberItemReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 06.01.2025.
//

import Testing
import Foundation

@testable import Memory

@Suite
final class EditWordRememberItemReducerTests {
    private static var rememberItemId = 1

    let reducer = EditWordRememberItemReducer()

    var state = EditWordRememberItemState(categoriesIds: [])

    var router = EditWordRememberItemRouterMock()

    @Test("Test cancel event")
    func testSendCancelOutputStateRouterRequestChanged() {
        reducer.reduce(state: &state, event: .cancel)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose)
    }

    @Test("Test wordDidChange event", arguments: ["Word", "Run"])
    func testSendEventWordDidChangeOutputStateWordChanged(word: String) {
        reducer.reduce(state: &state, event: .wordDidChange(word))

        #expect(state.word == word)
    }

    @Test("Test translationDidChange event", arguments: ["Слово", "Бег"])
    func testSendEventTranslationDidChangeOutputStateTranslationChanged(translation: String) {
        reducer.reduce(state: &state, event: .translationDidChange(translation))

        #expect(state.translation == translation)
    }

    @Test("Test transcriptionDidChange event", arguments: ["transcription", "transcription 2"])
    func testSendEventTranscriptionDidChangeOutputStateTranscriptionChanged(transcription: String) {
        reducer.reduce(state: &state, event: .transcriptionDidChange(transcription))

        #expect(state.transcription == transcription)
    }

    @Test("Test isLearningChanged event", arguments: [false, true])
    func testSendEventIsLearningChangedOutputStateIsLearningChanged(isLearning: Bool) {
        reducer.reduce(state: &state, event: .isLearningChanged(isLearning))

        #expect(state.isLearning == isLearning)
    }

    @Test("Test addNewExample event")
    func testSendEventAddNewExampleOutputStateExamplesChanged() {
        #expect(state.examples.isEmpty)

        reducer.reduce(state: &state, event: .addNewExample)

        #expect(!state.examples.isEmpty)
    }

    @Test("Test deleteExample event")
    func testSendEventDeleteExampleOutputStateExamplesChanged() {
        reducer.reduce(state: &state, event: .addNewExample)
        #expect(!state.examples.isEmpty)

        let firstExample = state.examples.first!

        reducer.reduce(state: &state, event: .deleteExample(id: firstExample.id))

        #expect(state.examples.isEmpty)
    }

    @Test("Test exampleChanged event")
    func testSendEventExampleChangedOutputStateExamplesChanged() {
        reducer.reduce(state: &state, event: .addNewExample)
        #expect(!state.examples.isEmpty)

        let firstExample = state.examples.first!
        let newExample = "new example"

        reducer.reduce(state: &state, event: .exampleChanged(id: firstExample.id, example: newExample))

        #expect(state.examples.first?.example == newExample)
    }

    @Test("Test exampleTranslationChanged event")
    func testSendEventExampleTranslationChangedOutputStateExamplesChanged() {
        reducer.reduce(state: &state, event: .addNewExample)
        #expect(!state.examples.isEmpty)

        let firstExample = state.examples.first!
        let newExampleTranslation = "new example translation"

        reducer.reduce(state: &state, event: .exampleTranslationChanged(id: firstExample.id, translation: newExampleTranslation))

        #expect(state.examples.first?.translation == newExampleTranslation)
    }

    @Test("Test addImage event")
    func testSendAddImageOutputStateRouterRequestChanged() {
        let word = "word"

        state.word = word
        reducer.reduce(state: &state, event: .addImage)

        performRouterRequest(from: state, to: router)

        #expect(router.didImagePickerWithText == word)
    }

    @Test("Test removeImage event")
    func testSendRemoveImageOutputStateImagesChanged() {
        let index = 0

        state.images = [.systemName("test")]
        reducer.reduce(state: &state, event: .removeImage(index: index))

        #expect(state.images.isEmpty)
    }

    @Test("Test removeImage event check if state.images is empty")
    func testSendRemoveImageOutputStateImagesNotChanged() {
        let index = 0

        reducer.reduce(state: &state, event: .removeImage(index: index))

        #expect(state.images.isEmpty)
    }

    @Test("Test imagesSelected event")
    func testSendImagesSelectedOutputStateImagesChanged() {
        let images: [ImageType] = [.systemName("123"), .data(Data())]

        reducer.reduce(state: &state, event: .imagesSelected(images))
        
        #expect(state.images.count == images.count)
    }

    @Test("Test save event create")
    func testSendSaveOutputStateCreateRequestChanged() {
        state.categoriesIds = [1, 2]
        state.word = "word"
        state.translation = "translation 14"
        state.transcription = "transcription 2"
        state.images = [.systemName("test")]
        state.examples = [.init(example: "word", translation: "слово")]

        reducer.reduce(state: &state, event: .save)

        #expect(state.createRequest?.payload.categoryIds == state.categoriesIds)
        #expect(state.createRequest?.payload.word?.word == state.word)
        #expect(state.createRequest?.payload.word?.translation == state.translation)
        #expect(state.createRequest?.payload.word?.transcription == state.transcription)
        #expect(state.createRequest?.payload.word?.images == state.images)
        #expect(state.createRequest?.payload.word?.examples == state.examples)
    }

    @Test("Test save event empty word")
    func testSendSaveOutputStateCreateRequestNotChanged() {
        state.categoriesIds = [1, 2]
        state.word = ""
        state.translation = "translation 14"
        state.transcription = "transcription 2"
        state.images = [.systemName("test")]
        state.examples = [.init(example: "word", translation: "слово")]

        reducer.reduce(state: &state, event: .save)

        #expect(state.createRequest == nil)
    }

    @Test("Test save event update")
    func testSendSaveOutputStateUpdateRequestChanged() {
        state.rememberItem = MockRememberItemModel.mockRememberItemModel()
        state.categoriesIds = [1, 2]
        state.word = "word"
        state.translation = "translation 14"
        state.transcription = "transcription 2"
        state.images = [.systemName("test")]
        state.examples = [.init(example: "word", translation: "слово")]

        reducer.reduce(state: &state, event: .save)

        #expect(state.updateRequest?.payload.categoryIds == state.categoriesIds)
        #expect(state.updateRequest?.payload.word?.word == state.word)
        #expect(state.updateRequest?.payload.word?.translation == state.translation)
        #expect(state.updateRequest?.payload.word?.transcription == state.transcription)
        #expect(state.updateRequest?.payload.word?.images == state.images)
        #expect(state.updateRequest?.payload.word?.examples == state.examples)
    }

    @Test("Test itemFetched event success result")
    func testSendItemFetchedOutputStateRememberItemChanged() {
        let rememberItem = MockRememberItemModel.mockRememberItemModel()
        state.fetchRequest = FeedbackRequest(.init(id: rememberItem.id))
        reducer.reduce(state: &state, event: .itemFetched(.success(rememberItem)))

        #expect(state.fetchRequest == nil)
        #expect(state.categoriesIds == rememberItem.categoriesIds)
        #expect(state.word == rememberItem.word?.word)
        #expect(state.translation == rememberItem.word?.translation)
        #expect(state.transcription == rememberItem.word?.transcription)
        #expect(state.examples == rememberItem.word?.examples)
        #expect(state.images == rememberItem.word?.images)
    }

    @Test("Test itemFetched event failure result")
    func testSendItemFetchedOutputStateRememberItemNotChanged() {
        state.fetchRequest = FeedbackRequest(.init(id: 1))
        reducer.reduce(state: &state, event: .itemFetched(.failure(MockError.mockError)))

        #expect(state.fetchRequest == nil)
    }

    @Test("Test itemCreated event success result")
    func testSendItemCreatedOutputStateRouterRequestChanged() {
        let rememberItem = MockRememberItemModel.mockRememberItemModel()
        state.createRequest = FeedbackRequest(MockRememberItemModel.mockNewRememberItemModel())

        reducer.reduce(state: &state, event: .itemCreated(.success(rememberItem)))

        #expect(state.createRequest == nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose)
    }

    @Test("Test itemUpdated event success result")
    func testSendItemUpdatedOutputStateRouterRequestChanged() {
        let rememberItem = MockRememberItemModel.mockRememberItemModel()
        state.updateRequest = FeedbackRequest(MockRememberItemModel.mockUpdateRememberItemModel())

        reducer.reduce(state: &state, event: .itemUpdated(.success(rememberItem)))

        #expect(state.updateRequest == nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose)
    }
}

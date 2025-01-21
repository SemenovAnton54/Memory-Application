//
//  LearnCardReducer+WordTests.swift
//  Memory
//
//  Created by Anton Semenov on 08.01.2025.
//

import Testing

@testable import Memory

extension LearnCardReducerTests {
    @Test("Test wordCardEvent + enteringWord event", arguments: ["testWord", "to test"])
    func sendEvent_wordCardEvent_withInput_enteringWord_output_state_wordCardStateEnteringWord_changed(testWord: String) {
        let wordState = LearnCardState.WordCardState()
        state.wordCardState = wordState

        reducer.reduce(state: &state, event: .wordCardEvent(.enteringWord(testWord)))
        #expect(state.wordCardState?.enteringWord == testWord)
    }

    @Test("Test wordCardEvent + playExample event", arguments: ["testWord", "to test"])
    func sendEvent_wordCardEvent_withInput_playExample_output_state_playTextRequest_changed(example: String) {
        reducer.reduce(state: &state, event: .wordCardEvent(.playExample(.init(example: example, translation: ""))))
        #expect(state.playTextRequest?.payload == example)
    }

    @Test("Test wordCardEvent + correctAnswerAnimationFinished event")
    func sendEvent_wordCardEvent_withInput_correctAnswerAnimationFinished_output_state_wordCardStateZctionStyle_changed() {
        state.rememberCardItemModel = rememberCardItemModel
        state.wordCardState = .init()

        reducer.reduce(state: &state, event: .wordCardEvent(.correctAnswerAnimationFinished))

        #expect(state.wordCardState?.actionStyle == .answer)
        #expect(state.playTextRequest?.payload == state.rememberCardItemModel?.word?.word)
    }

    @Test(
        "Test wordCardEvent + changeActionStyle event",
        arguments: [
            LearnCardState.WordCardState.ActionStyle.buttons,
            LearnCardState.WordCardState.ActionStyle.textField,
            LearnCardState.WordCardState.ActionStyle.variants,
            LearnCardState.WordCardState.ActionStyle.answer
        ]
    )
    func sendEvent_wordCardEvent_withInput_changeActionStyle_output_state_wordCardStateEnteringWord_changed(
        actionStyle: LearnCardState.WordCardState.ActionStyle
    ) {
        state.rememberCardItemModel = rememberCardItemModel
        state.wordCardState = .init()
        reducer.reduce(state: &state, event: .wordCardEvent(.changeActionStyle(actionStyle)))
        #expect(state.wordCardState?.actionStyle == actionStyle)

        switch actionStyle {
        case .buttons, .textField, .variants:
            break
        case .answer:
            #expect(state.playTextRequest?.payload == rememberCardItemModel.word?.word)
        }
    }

    @Test("Test wordCardEvent + checkAnswer event", arguments: ["testWord", "to test"])
    func sendEvent_wordCardEvent_withInput_checkAnswer_output_state_wordCardStateActionStyleOrWrongAnswersCount_changed(testWord: String) {
        let rememberCardItemModel = MockRememberItemModel.mockRememberItemModel(
            word: .init(
                id: 1,
                word: testWord,
                transcription: "transcription",
                translation: "translation",
                examples: [],
                images: []
            )
        )
        let wordState = LearnCardState.WordCardState()
        let word = rememberCardItemModel.word?.word
        #expect(word?.isEmpty == false)

        state.rememberCardItemModel = rememberCardItemModel

        state.wordCardState?.enteringWord = testWord
        reducer.reduce(state: &state, event: .wordCardEvent(.checkAnswer))
        #expect(state.wordCardState != nil)

        state.wordCardState = wordState
        reducer.reduce(state: &state, event: .wordCardEvent(.checkAnswer))
        #expect(state.wordCardState?.wrongAnswersCount == 1)

        reducer.reduce(state: &state, event: .wordCardEvent(.checkAnswer))
        #expect(state.wordCardState?.wrongAnswersCount == 2)

        state.wordCardState?.enteringWord = testWord
        let previousState = state.wordCardState!.actionStyle
        
        reducer.reduce(state: &state, event: .wordCardEvent(.checkAnswer))
        #expect(state.wordCardState?.actionStyle == previousState)
        #expect(state.wordCardState?.isAnswered == true)
    }

    @Test("Test wordCardEvent + WordCardEvent event", arguments: ["testWord", "to test"])
    func sendEvent_wordCardEvent_withInput_addNextLetter_output_state_wordCardStateEnteringWord_changed(testWord: String) {
        let rememberCardItemModel = MockRememberItemModel.mockRememberItemModel(
            word: .init(
                id: 1,
                word: testWord,
                transcription: "transcription",
                translation: "translation",
                examples: [],
                images: []
            )
        )
        let wordState = LearnCardState.WordCardState()
        let word = rememberCardItemModel.word?.word
        #expect(word?.isEmpty == false)

        state.wordCardState = wordState
        state.rememberCardItemModel = rememberCardItemModel

        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == testWord.prefix(1).toString())

        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == testWord.prefix(2).toString())

        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == testWord.prefix(3).toString())

        state.wordCardState?.enteringWord = testWord.prefix(3).toString() + "1"
        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == testWord.prefix(3).toString())

        state.wordCardState?.enteringWord = testWord
        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == testWord)

        state.wordCardState?.enteringWord = "111"
        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == "")

        state.wordCardState?.enteringWord = testWord + "www"
        reducer.reduce(state: &state, event: .wordCardEvent(.addNextLetter))
        #expect(state.wordCardState?.enteringWord == testWord)
    }
}

//
//  LearnCardReducer+WordCardEvents.swift
//  Memory
//

extension LearnCardReducer {
    func onWordCardEvent(state: inout LearnCardState, event: LearnCardEvent.WordCardEvent) {
        switch event {
        case .addNextLetter:
            onAddNextLetter(state: &state)
        case .checkAnswer:
            onCheckAnswer(state: &state)
        case let .enteringWord(word):
            onEnteringWord(word: word, state: &state)
        case let .playExample(example):
            onPlayExample(example: example, state: &state)
        case let .changeActionStyle(style):
            onChangeActionStyle(style: style, state: &state)
        case .correctAnswerAnimationFinished:
            onCorrectAnswerAnimationFinished(state: &state)
        }
    }

    func onAddNextLetter(state: inout LearnCardState) {
        guard let word = state.rememberCardItemModel?.word?.word.lowercased(),
              let wordCardState = state.wordCardState else {
            return
        }

        let enteringWord = wordCardState.enteringWord.lowercased()

        guard !enteringWord.isEmpty else {
            state.wordCardState?.enteringWord = word.first?.lowercased() ?? ""
            return
        }

        let wordArray = Array(word)
        var enteringWordChanged = false
        state.wordCardState?.enteringWord = ""
        
        for item in enteringWord.enumerated() {
            guard let nextWordSymbol = wordArray[safe: item.offset] else {
                state.wordCardState?.enteringWord = String(wordCardState.enteringWord.prefix(wordArray.count))
                enteringWordChanged = true
                break
            }

            guard item.element == nextWordSymbol else {
                enteringWordChanged = true
                break
            }

            state.wordCardState?.enteringWord = String(wordCardState.enteringWord.prefix(item.offset + 1))
        }

        guard !enteringWordChanged else {
            return
        }

        guard enteringWord.lowercased() != state.rememberCardItemModel?.word?.word.lowercased() else {
            return
        }

        state.wordCardState?.enteringWord += String(wordArray[wordCardState.enteringWord.count])
    }

    func onCorrectAnswerAnimationFinished(state: inout LearnCardState) {
        state.wordCardState?.actionStyle = .answer

        guard let word = state.rememberCardItemModel?.word?.word else {
            return
        }

        state.playTextRequest = FeedbackRequest(word)
    }

    func onCheckAnswer(state: inout LearnCardState) {
        guard let wordCardState = state.wordCardState else {
            state.wordCardState = .init()
            return
        }

        guard wordCardState.enteringWord.lowercased() == state.rememberCardItemModel?.word?.word.lowercased() else {
            state.wordCardState?.wrongAnswersCount += 1
            return
        }

        state.wordCardState?.actionStyle = .correctAnswerAnimation(from: wordCardState.actionStyle)
    }

    func onEnteringWord(word: String, state: inout LearnCardState) {
        state.wordCardState?.enteringWord = word
    }

    func onPlayExample(example: WordExampleModel, state: inout LearnCardState) {
        state.playTextRequest = FeedbackRequest(example.example)
    }

    func onChangeActionStyle(style: LearnCardState.WordCardState.ActionStyle, state: inout LearnCardState) {
        state.wordCardState?.actionStyle = style

        guard style == .answer, let word = state.rememberCardItemModel?.word?.word else {
            return
        }

        state.playTextRequest = FeedbackRequest(word)
    }
}

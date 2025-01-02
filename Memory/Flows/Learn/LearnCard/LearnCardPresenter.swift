//
//  LearnCardPresenter.swift
//  Memory
//

struct LearnCardPresenter {
    func present(state: LearnCardState) -> LearnCardViewState {
        LearnCardViewState(
            isLoading: isLoading(state: state),
            wordCardViewState: wordCardViewState(state: state),
            rememberItemViewModel: rememberItemViewModel(state: state)
        )
    }
}

extension LearnCardPresenter {
    func isLoading(state: LearnCardState) -> Bool {
        state.nextCardRequest != nil
    }
    
    func wordCardViewState(state: LearnCardState) -> LearnCardViewState.WordCardViewState? {
        guard let wordCardState = state.wordCardState, let word = state.rememberCardItemModel?.word else {
            return nil
        }

        return LearnCardViewState.WordCardViewState(
            word: WordViewModel(from: word),
            isImagesHidden: state.rememberCardItemModel?.repeatLevel == .newItem,
            actionStyle: wordCardState.actionStyle,
            enteringWord: wordCardState.enteringWord,
            wrongAnswersCount: wordCardState.wrongAnswersCount
        )
    }

    func rememberItemViewModel(state: LearnCardState) -> RememberCardItemViewModel? {
        guard let model = state.rememberCardItemModel else {
            return nil
        }

        return RememberCardItemViewModel(from: model)
    }
}

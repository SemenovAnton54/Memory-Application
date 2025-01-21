//
//  LearnCardViewState.swift
//  Memory
//

struct LearnCardViewState {
    struct WordCardViewState {
        let word: WordViewModel
        let isImagesHidden: Bool
        let actionStyle: LearnCardState.WordCardState.ActionStyle
        let enteringWord: String
        let wrongAnswersCount: Int
        let showCorrectAnswerAnimation: Bool
    }

    let isLoading: Bool
    let wordCardViewState: WordCardViewState?
    let rememberItemViewModel: RememberCardItemViewModel?
}

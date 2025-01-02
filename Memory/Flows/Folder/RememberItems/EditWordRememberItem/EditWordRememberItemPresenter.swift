//
//  EditWordRememberItemPresenter.swift
//  Memory
//

struct EditWordRememberItemPresenter {
    func present(state: EditWordRememberItemState) -> EditWordRememberItemViewState {
        EditWordRememberItemViewState(
            isLoading: isLoading(state: state),
            isNewRememberItem: isNewRememberItem(state: state),
            word: state.word,
            translation: state.translation,
            transcription: state.transcription,
            images: state.images.enumerated().map { ImageViewModel(id: $0.offset, imageObject: $0.element) },
            isLearning: state.isLearning,
            examples: state.examples
        )
    }
}

extension EditWordRememberItemPresenter {
    func isNewRememberItem(state: EditWordRememberItemState) -> Bool {
        state.rememberItem == nil || state.fetchRequest != nil
    }

    func isLoading(state: EditWordRememberItemState) -> Bool {
        state.fetchRequest != nil
    }
}

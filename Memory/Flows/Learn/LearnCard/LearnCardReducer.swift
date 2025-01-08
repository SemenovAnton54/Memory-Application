//
//  LearnCardReducer.swift
//  Memory
//

struct LearnCardReducer {
    typealias CardRequest = LearnCardState.CardRequest

    func reduce(state: inout LearnCardState, event: LearnCardEvent) {
        switch event {
        case let .wordCardEvent(event):
            onWordCardEvent(state: &state, event: event)
        case .remember:
            onRemember(state: &state)
        case .notRemember:
            onNotRemember(state: &state)
        case .editCard:
            onEditCard(state: &state)
        case let .cardItemRepeatLevelChanged(result):
            onCardItemRepeatLevelChanged(result: result, state: &state)
        case let .nextCardItemFetched(result):
            onNextCardItemLoaded(result: result, state: &state)
        case .playingTextStarted:
            onPlayingTextStarted(state: &state)
        case let .rememberItemUpdated(id):
            onRememberItemUpdated(id: id, state: &state)
        case let .updatedCardItemFetched(result):
            onUpdatedCardItemFetched(result: result, state: &state)
        }
    }
}

// MARK: - Event handlers

extension LearnCardReducer {
    func onRemember(state: inout LearnCardState) {
        guard let id = state.rememberCardItemModel?.id else {
            return
        }

        state.cardItemRememberedRequest = FeedbackRequest(id)
    }

    func onRememberItemUpdated(id: Int, state: inout LearnCardState) {
        guard state.rememberCardItemModel?.id == id,
              state.cardItemForgottenRequest == nil,
              state.cardItemRememberedRequest == nil,
              state.nextCardRequest == nil else {
            return
        }

        state.fetchUpdatedCardRequest = FeedbackRequest(CardRequest(id: id))
    }

    func onNotRemember(state: inout LearnCardState) {
        guard let id = state.rememberCardItemModel?.id else {
            return
        }

        state.cardItemForgottenRequest = FeedbackRequest(id)
    }

    func onPlayingTextStarted(state: inout LearnCardState) {
        state.playTextRequest = nil
    }

    func onEditCard(state: inout LearnCardState) {
        guard let id = state.rememberCardItemModel?.id else {
            return
        }

        state.requestRoute {
            $0.editRememberItem(id: id)
        }
    }

    func onCardItemRepeatLevelChanged(result: Result<RememberCardItemModel, Error>, state: inout LearnCardState) {
        state.cardItemRememberedRequest = nil
        state.cardItemForgottenRequest = nil

        state.nextCardRequest = FeedbackRequest()
    }

    func onUpdatedCardItemFetched(result: Result<RememberCardItemModel, Error>, state: inout LearnCardState) {
        state.fetchUpdatedCardRequest = nil

        switch result {
        case let .success(model):
            guard state.rememberCardItemModel?.id == model.id else {
                break
            }

            state.rememberCardItemModel = model
        case .failure:
            break
        }
    }

    func onNextCardItemLoaded(result: Result<RememberCardItemModel?, Error>, state: inout LearnCardState) {
        state.nextCardRequest = nil

        switch result {
        case let .success(item):
            state.rememberCardItemModel = item
            state.wordCardState = .init()
        case .failure:
            break
        }
    }
}

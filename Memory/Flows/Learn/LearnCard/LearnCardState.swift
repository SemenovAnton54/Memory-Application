//
//  LearnCardState.swift
//  Memory
//

struct LearnCardState {
    struct CardRequest {
        let id: Int
    }

    struct WordCardState {
        indirect enum ActionStyle: Equatable {
            case buttons
            case textField
            case variants
            case answer
            case correctAnswerAnimation(from: ActionStyle)
        }

        var actionStyle: ActionStyle = .buttons
        var enteringWord: String = ""
        var wrongAnswersCount: Int = 0
    }

    var rememberCardItemModel: RememberCardItemModel?
    var wordCardState: WordCardState?

    var playTextRequest: FeedbackRequest<String>?
    var nextCardRequest: FeedbackRequest<()>?
    var fetchUpdatedCardRequest: FeedbackRequest<CardRequest>?
    var statisticsRequest: FeedbackRequest<()>?
    var cardItemRememberedRequest: FeedbackRequest<Int>?
    var cardItemForgottenRequest: FeedbackRequest<Int>?
    var routingRequest: RoutingFeedbackRequest<LearnCardRouterProtocol, LearnCardEvent>?
}

extension LearnCardState: RoutingStateProtocol {}

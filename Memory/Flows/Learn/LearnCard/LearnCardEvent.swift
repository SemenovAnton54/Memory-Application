//
//  LearnCardEvent.swift
//  Memory
//

enum LearnCardEvent {
    case wordCardEvent(WordCardEvent)
    
    case remember
    case notRemember

    case editCard

    case playingTextStarted

    case rememberItemUpdated(id: Int)
    case cardItemRepeatLevelChanged(Result<RememberCardItemModel, Error>)
    case updatedCardItemFetched(Result<RememberCardItemModel, Error>)
    case nextCardItemFetched(Result<RememberCardItemModel?, Error>)
}

extension LearnCardEvent {
    enum WordCardEvent {
        case addNextLetter
        case checkAnswer
        case enteringWord(String)
        case playExample(WordExampleModel)
        case changeActionStyle(LearnCardState.WordCardState.ActionStyle)
        case correctAnswerAnimationFinished
    }
}

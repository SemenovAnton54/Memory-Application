//
//  SelectFolderLearningModeEvent.swift
//  Memory
//

enum SelectFolderLearningModeEvent {
    case learnNewCards
    case reviewCards

    case newCardItemsStatisticsFetched(Result<LearnStatisticsModel, Error>)
    case reviewCardItemsStatisticsFetched(Result<LearnStatisticsModel, Error>)
}

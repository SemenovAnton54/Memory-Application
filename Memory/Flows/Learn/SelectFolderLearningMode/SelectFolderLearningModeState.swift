//
//  SelectFolderLearningModeState.swift
//  Memory
//

struct SelectFolderLearningModeState {
    let folderId: Int

    var newItemsStatistics: LearnStatisticsModel?
    var reviewItemsStatistics: LearnStatisticsModel?

    var fetchNewItemsStatisticsRequest: FeedbackRequest<()>?
    var fetchReviewItemsStatisticsRequest: FeedbackRequest<()>?

    var routingRequest: RoutingFeedbackRequest<SelectFolderLearningModeRouterProtocol, SelectFolderLearningModeEvent>?
}

extension SelectFolderLearningModeState: RoutingStateProtocol {}

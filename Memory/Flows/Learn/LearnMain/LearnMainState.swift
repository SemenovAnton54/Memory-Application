//
//  LearnMainState.swift
//  Memory
//

struct LearnMainState {
    struct FavoriteFolderModel {
        let folder: FolderModel
        let newCardsStatistics: LearnStatisticsModel
        let reviewCardsStatistics: LearnStatisticsModel
    }

    var favoriteFolders: [FavoriteFolderModel] = []
    var foldersExists: Bool = false

    var fetchFavoriteFoldersRequest: FeedbackRequest<()>?
    var foldersExistsRequest: FeedbackRequest<()>?
    var routingRequest: RoutingFeedbackRequest<LearnMainRouterProtocol, LearnMainEvent>?
}

extension LearnMainState: RoutingStateProtocol {}

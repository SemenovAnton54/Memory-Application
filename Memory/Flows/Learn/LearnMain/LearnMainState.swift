//
//  LearnMainState.swift
//  Memory
//

struct LearnMainState {
    var favoriteFolders: [FolderModel] = []
    var foldersExists: Bool = false

    var fetchFavoriteFoldersRequest: FeedbackRequest<()>?
    var foldersExistsRequest: FeedbackRequest<()>?
    var routingRequest: RoutingFeedbackRequest<LearnMainRouterProtocol, LearnMainEvent>?
}

extension LearnMainState: RoutingStateProtocol {}

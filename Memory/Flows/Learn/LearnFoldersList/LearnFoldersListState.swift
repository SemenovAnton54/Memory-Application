//
//  LearnFoldersListState.swift
//  Memory
//

struct LearnFoldersListState {
    var folders: [FolderModel] = []

    var fetchFoldersRequest: FeedbackRequest<()>? = FeedbackRequest()
    var routingRequest: RoutingFeedbackRequest<LearnFoldersListRouterProtocol, LearnFoldersListEvent>?
}

extension LearnFoldersListState: RoutingStateProtocol {}

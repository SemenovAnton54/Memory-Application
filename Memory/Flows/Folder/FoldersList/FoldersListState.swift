//
//  FoldersListState.swift
//  Memory
//

struct FoldersListState {
    var folders: [FolderModel] = []

    var fetchFoldersRequest: FeedbackRequest<()>? = FeedbackRequest()
    var routingRequest: RoutingFeedbackRequest<FoldersListRouterProtocol, FoldersListEvent>?
}

extension FoldersListState: RoutingStateProtocol {}

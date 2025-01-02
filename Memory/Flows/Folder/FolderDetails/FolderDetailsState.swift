//
//  FolderDetailsState.swift
//  Memory
//

struct FolderDetailsState {
    struct FolderRequest {
        let id: Int
    }

    struct CategoriesRequest {
        let folderId: Int
    }

    let id: Int

    var folder: FolderModel?
    var categories: [CategoryModel] = []

    var deleteFolderRequest: FeedbackRequest<FolderRequest>?
    var fetchFolderRequest: FeedbackRequest<FolderRequest>?
    var categoriesRequest: FeedbackRequest<CategoriesRequest>?
    var routingRequest: RoutingFeedbackRequest<FolderDetailsRouterProtocol, FolderDetailsEvent>?
}

extension FolderDetailsState: RoutingStateProtocol {}

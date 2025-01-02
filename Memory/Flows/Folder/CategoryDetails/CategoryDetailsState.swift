//
//  CategoryDetailsState.swift
//  Memory
//

struct CategoryDetailsState {
    struct CategoryRequest {
        let id: Int
    }

    struct RememberItemsRequest {
        let categoryId: Int
    }

    struct RememberItemRequest {
        let id: Int
    }

    let id: Int

    var category: CategoryModel?
    var rememberItems: [RememberCardItemModel] = []

    var deleteCategoryRequest: FeedbackRequest<CategoryRequest>?
    var deleteRememberItemRequest: FeedbackRequest<RememberItemRequest>?
    var categoryRequest: FeedbackRequest<CategoryRequest>?
    var rememberItemsRequest: FeedbackRequest<RememberItemsRequest>?

    var routingRequest: RoutingFeedbackRequest<CategoryDetailsRouterProtocol, CategoryDetailsEvent>?
}

extension CategoryDetailsState: RoutingStateProtocol {}

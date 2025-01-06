//
//  CategoryDetailsReducer.swift
//  Memory
//

struct CategoryDetailsReducer {
    typealias CategoryRequest = CategoryDetailsState.CategoryRequest
    typealias RememberItemsRequest = CategoryDetailsState.RememberItemsRequest
    typealias RememberItemRequest = CategoryDetailsState.RememberItemRequest

    func reduce(state: inout CategoryDetailsState, event: CategoryDetailsEvent) {
        switch event {
        case let .categoryFetched(result):
            onCategoryFetched(result: result, state: &state)
        case .addRememberItem:
            onAddRemember(state: &state)
        case let .editRememberItem(id):
            onEditRememberItem(id: id, state: &state)
        case .editCategory:
            onEditCategory(state: &state)
        case let .rememberItemsFetched(result):
            onRememberItemsFetched(result: result, state: &state)
        case .categoryChanged:
            onCategoryChanged(state: &state)
        case .deleteCategory:
            onDeleteCategory(state: &state)
        case let .categoryDeleted(result):
            onCategoryDeleted(result: result, state: &state)
        case let .deleteRememberItem(id):
            onDeleteRememberItem(id: id, state: &state)
        case let .rememberItemDeleted(result):
            onRememberItemDeleted(result: result, state: &state)
        }
    }
}

// MARK: - Event handlers

private extension CategoryDetailsReducer {
    func onEditCategory(state: inout CategoryDetailsState) {
        let id = state.id

        state.requestRoute {
            $0.editCategory(id: id)
        }
    }

    func onAddRemember(state: inout CategoryDetailsState) {
        let id = state.id

        state.requestRoute {
            $0.newRememberItem(for: id)
        }
    }

    func onEditRememberItem(id: Int, state: inout CategoryDetailsState) {
        state.requestRoute {
            $0.editRememberItem(id: id)
        }
    }

    func onDeleteRememberItem(id: Int, state: inout CategoryDetailsState) {
        state.deleteRememberItemRequest = FeedbackRequest(RememberItemRequest(id: id))
    }

    func onDeleteCategory(state: inout CategoryDetailsState) {
        state.deleteCategoryRequest = FeedbackRequest(CategoryRequest(id: state.id))
    }

    func onCategoryChanged(state: inout CategoryDetailsState) {
        state.fetchCategoryRequest = FeedbackRequest(CategoryRequest(id: state.id))
        state.fetchRememberItemsRequest = FeedbackRequest(RememberItemsRequest(categoryId: state.id))
    }

    func onCategoryFetched(result: Result<CategoryModel, Error>, state: inout CategoryDetailsState) {
        state.fetchCategoryRequest = nil

        switch result {
        case let .success(category):
            state.category = category
        case .failure:
            state.category = nil
        }
    }

    func onCategoryDeleted(result: Result<CategoryModel, Error>, state: inout CategoryDetailsState) {
        state.deleteCategoryRequest = nil

        state.requestRoute {
            $0.close()
        }
    }

    func onRememberItemsFetched(result: Result<[RememberCardItemModel], Error>, state: inout CategoryDetailsState) {
        state.fetchRememberItemsRequest = nil

        switch result {
        case let .success(rememberItems):
            state.rememberItems = rememberItems
        case .failure:
            state.rememberItems = []
        }
    }

    func onRememberItemDeleted(result: Result<RememberCardItemModel, Error>, state: inout CategoryDetailsState) {
        state.deleteRememberItemRequest = nil

        switch result {
        case let .success(rememberItem):
            state.rememberItems.removeAll(where: { $0.id == rememberItem.id })
        case .failure:
            state.fetchRememberItemsRequest = FeedbackRequest(RememberItemsRequest(categoryId: state.id))
        }
    }
}

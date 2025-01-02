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
        case .addRememberItemTapped:
            onAddRememberTapped(state: &state)
        case let .editRememberItemTapped(id):
            onEditRememberItemTapped(id: id, state: &state)
        case .editCategoryTapped:
            onEditCategoryTapped(state: &state)
        case let .rememberItemsFetched(result):
            onRememberItemsFetched(result: result, state: &state)
        case .categoryChanged:
            onCategoryChanged(state: &state)
        case .deleteCategoryTapped:
            onDeleteCategoryTapped(state: &state)
        case let .categoryDeleted(result):
            onCategoryDeleted(result: result, state: &state)
        case let .deleteRememberItemTapped(id):
            onDeleteRememberItemTapped(id: id, state: &state)
        case let .rememberItemDeleted(result):
            onRememberItemDeleted(result: result, state: &state)
        }
    }
}

// MARK: - Event handlers

private extension CategoryDetailsReducer {
    func onEditCategoryTapped(state: inout CategoryDetailsState) {
        let id = state.id

        state.requestRoute {
            $0.editCategory(id: id)
        }
    }

    func onAddRememberTapped(state: inout CategoryDetailsState) {
        let id = state.id

        state.requestRoute {
            $0.newRememberItem(for: id)
        }
    }

    func onEditRememberItemTapped(id: Int, state: inout CategoryDetailsState) {
        state.requestRoute {
            $0.editRememberItem(id: id)
        }
    }

    func onDeleteRememberItemTapped(id: Int, state: inout CategoryDetailsState) {
        state.deleteRememberItemRequest = FeedbackRequest(RememberItemRequest(id: id))
    }

    func onDeleteCategoryTapped(state: inout CategoryDetailsState) {
        state.deleteCategoryRequest = FeedbackRequest(CategoryRequest(id: state.id))
    }

    func onCategoryChanged(state: inout CategoryDetailsState) {
        state.categoryRequest = FeedbackRequest(CategoryRequest(id: state.id))
        state.rememberItemsRequest = FeedbackRequest(RememberItemsRequest(categoryId: state.id))
    }

    func onCategoryFetched(result: Result<CategoryModel, Error>, state: inout CategoryDetailsState) {
        state.categoryRequest = nil

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
        state.rememberItemsRequest = nil

        switch result {
        case let .success(rememberItems):
            state.rememberItems = rememberItems
        case .failure:
            state.rememberItems = []
        }
    }

    func onRememberItemDeleted(result: Result<RememberCardItemModel, Error>, state: inout CategoryDetailsState) {
        state.rememberItemsRequest = nil

        switch result {
        case let .success(rememberItem):
            state.rememberItems.removeAll(where: { $0.id == rememberItem.id })
        case .failure:
            state.rememberItemsRequest = FeedbackRequest(RememberItemsRequest(categoryId: state.id))
        }
    }
}

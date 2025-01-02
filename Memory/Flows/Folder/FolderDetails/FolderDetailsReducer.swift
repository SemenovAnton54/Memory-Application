//
//  FolderDetailsReducer.swift
//  Memory
//

struct FolderDetailsReducer {
    typealias CategoriesRequest = FolderDetailsState.CategoriesRequest
    typealias FolderRequest = FolderDetailsState.FolderRequest

    func reduce(state: inout FolderDetailsState, event: FolderDetailsEvent) {
        switch event {
        case let .folderFetched(result):
            onFolderFetched(result: result, state: &state)
        case let .folderDeleted(result):
            onFolderDeleted(result: result, state: &state)
        case .addCategoryTapped:
            onAddCategoryTapped(state: &state)
        case let .categoryDetailsTapped(id):
            onCategoryDetailsTapped(id: id, state: &state)
        case .editFolderTapped:
            onEditFolderTapped(state: &state)
        case let .categoriesFetched(result):
            onCategoriesFetched(result: result, state: &state)
        case .categoriesChanged:
            onCategoriesChanged(state: &state)
        case .deleteFolderTapped:
            onDeleteFolderTapped(state: &state)
        }
    }
}

// MARK: - Event handlers

private extension FolderDetailsReducer {
    func onEditFolderTapped(state: inout FolderDetailsState) {
        let id = state.id
        
        state.requestRoute {
            $0.editFolder(id: id)
        }
    }

    func onDeleteFolderTapped(state: inout FolderDetailsState) {
        let id = state.id
        
        state.deleteFolderRequest = FeedbackRequest(FolderRequest(id: id))
    }

    func onAddCategoryTapped(state: inout FolderDetailsState) {
        let id = state.id

        state.requestRoute {
            $0.newCategory(for: id)
        }
    }

    func onCategoryDetailsTapped(id: Int, state: inout FolderDetailsState) {
        state.requestRoute {
            $0.categoryDetails(id: id)
        }
    }

    func onCategoriesChanged(state: inout FolderDetailsState) {
        state.categoriesRequest = FeedbackRequest(CategoriesRequest(folderId: state.id))
    }

    func onFolderFetched(result: Result<FolderModel, Error>, state: inout FolderDetailsState) {
        state.fetchFolderRequest = nil

        switch result {
        case let .success(folder):
            state.folder = folder
        case .failure:
            state.folder = nil
        }
    }

    func onFolderDeleted(result: Result<FolderModel, Error>, state: inout FolderDetailsState) {
        state.deleteFolderRequest = nil

        switch result {
        case .success:
            state.requestRoute {
                $0.close()
            }
        case .failure:
            break
        }
    }

    func onCategoriesFetched(result: Result<[CategoryModel], Error>, state: inout FolderDetailsState) {
        state.categoriesRequest = nil

        switch result {
        case let .success(categories):
            state.categories = categories
        case .failure:
            state.categories = []
        }
    }
}

//
//  LearnMainReducer.swift
//  Memory
//

struct LearnMainReducer {
    func reduce(state: inout LearnMainState, event: LearnMainEvent) {
        switch event {
        case let .folderSelected(id):
            onFolderSelected(id: id, state: &state)
        case .showAllFolders:
            onShowAllFolders(state: &state)
        case let .favoriteFoldersFetched(result):
            onFavoriteFoldersFetched(result: result, state: &state)
        case .refresh:
            onRefresh(state: &state)
        case .onAppear:
            onAppear(state: &state)
        case let .foldersExist(result):
            onFoldersExist(result: result, state: &state)
        }
    }
}

// MARK: - Event handlers

private extension LearnMainReducer {
    func onAppear(state: inout LearnMainState) {
        state.foldersExistsRequest = FeedbackRequest()
    }

    func onFolderSelected(id: Int, state: inout LearnMainState) {
        state.requestRoute {
            $0.selectLearnMode(for: id)
        }
    }

    func onShowAllFolders(state: inout LearnMainState) {
        state.requestRoute {
            $0.learnFolders()
        }
    }

    func onRefresh(state: inout LearnMainState) {
        state.fetchFavoriteFoldersRequest = FeedbackRequest()
    }

    func onFavoriteFoldersFetched(result: Result<[FolderModel], Error>, state: inout LearnMainState) {
        state.fetchFavoriteFoldersRequest = nil

        switch result {
        case let .success(folders):
            state.favoriteFolders = folders
        case .failure:
            state.favoriteFolders = []
        }
    }

    func onFoldersExist(result: Result<Bool, Error>, state: inout LearnMainState) {
        state.foldersExistsRequest = nil

        switch result {
        case let .success(value):
            state.foldersExists = value
        case .failure:
            state.foldersExists = false
        }
    }
}

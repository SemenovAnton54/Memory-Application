//
//  LearnFoldersListReducer.swift
//  Memory
//

struct LearnFoldersListReducer {
    func reduce(state: inout LearnFoldersListState, event: LearnFoldersListEvent) {
        switch event {
        case let .foldersFetched(result):
            onFoldersFetched(result: result, state: &state)
        case let .folderSelected(id):
            onFolderSelected(id: id, state: &state)
        }
    }
}

// MARK: - Event handlers

private extension LearnFoldersListReducer {
    func onFolderSelected(id: Int, state: inout LearnFoldersListState) {
        state.requestRoute {
            $0.learnFolder(id: id)
        }
    }

    func onFoldersFetched(result: Result<[FolderModel], Error>, state: inout LearnFoldersListState) {
        state.fetchFoldersRequest = nil

        switch result {
        case let .success(folders):
            state.folders = folders
        case .failure:
            break
        }
    }
}

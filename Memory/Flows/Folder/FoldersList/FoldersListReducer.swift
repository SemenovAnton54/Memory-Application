//
//  FoldersListReducer.swift
//  Memory
//

struct FoldersListReducer {
    func reduce(state: inout FoldersListState, event: FoldersListEvent) {
        switch event {
        case let .folderSelected(id):
            onFolderSelected(id: id, state: &state)
        case let .foldersFetched(result):
            onFoldersFetched(result: result, state: &state)
        case .newFolder:
            onNewFolder(state: &state)
        case .contentAppeared:
            onContentAppeared(state: &state)
        case .folderChanged:
            onFolderChanged(state: &state)
        }
    }
}

// MARK: - Event handlers

private extension FoldersListReducer {
    func onFolderSelected(id: Int, state: inout FoldersListState) {
        state.requestRoute {
            $0.openFolder(id: id)
        }
    }

    func onNewFolder(state: inout FoldersListState) {
        state.requestRoute {
            $0.newFolder()
        }
    }

    func onFolderChanged(state: inout FoldersListState) {
        state.fetchFoldersRequest = FeedbackRequest()
    }

    func onContentAppeared(state: inout FoldersListState) {
        state.fetchFoldersRequest = FeedbackRequest()
    }

    func onFoldersFetched(result: Result<[FolderModel], Error>, state: inout FoldersListState) {
        state.fetchFoldersRequest = nil

        switch result {
        case let .success(folders):
            state.folders = folders
        case .failure:
            break
        }
    }
}

//
//  LearnCoordinatorState+Routers.swift
//  Memory
//

extension LearnCoordinatorState {
    struct LearnCardRouter: LearnCardRouterProtocol {
        let state: LearnCoordinatorState

        func editRememberItem(id: Int) {
            state.presentedItem = .editRememberItem(id: id)
        }
    }

    struct LearnFoldersListRouter: LearnFoldersListRouterProtocol {
        let state: LearnCoordinatorState

        func learnFolder(id: Int) {
            state.nextItem = .selectMode(folderId: id)
        }
    }

    struct LearnMainRouter: LearnMainRouterProtocol {
        let state: LearnCoordinatorState
        
        func selectLearnMode(for folder: Int) {
            state.nextItem = .selectMode(folderId: folder)
        }

        func allFolders() {
            state.nextItem = .allFolders
        }

        func learnFolder(id: Int) {
            state.nextItem = .learnNewCards(folderId: id)
        }

        func reviewFolder(id: Int) {
            state.nextItem = .reviewCards(folderId: id)
        }
    }
}

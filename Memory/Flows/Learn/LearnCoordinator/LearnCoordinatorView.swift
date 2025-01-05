//
//  LearnCoordinatorView.swift
//  Memory
//

import SwiftUI

struct LearnCoordinatorView: View {
    @ObservedObject var state: LearnCoordinatorState

    var body: some View {
        linkDestination(link: state.route)
            .navigationDestination(item: $state.nextItem) {
                switch $0 {
                default:
                    if let state = state.nextItemCoordinatorState(for: $0) {
                        LearnCoordinatorFactory().makeView(for: state)
                    } else {
                        EmptyView()
                    }

                }
            }
            .sheet(item: $state.presentedItem, content: sheetContent)
    }

    @ViewBuilder func sheetContent(item: LearnRoute) -> some View {
        switch item {
        case .main:
            LearnMainView(store: state.learnMainStore())
        case let .editRememberItem(id):
            RememberItemCoordinatorFactory().makeView(
                for: state.rememberItemCoordinatorState(
                    router: .editWordRememberItem(
                        id: id,
                        categoriesIds: nil
                    )
                )
            )
        default:
            EmptyView()
        }
    }

    @ViewBuilder func linkDestination(link: LearnRoute) -> some View {
        switch link {
        case .main:
            LearnMainView(store: state.learnMainStore())
        case let .selectMode(folderId):
            SelectFolderLearningModeView(store: state.startFolderLearningModeStore(folderId: folderId))
        case let .learnNewCards(folderId):
            LearnCardView(store: state.learnNewCards(folderId: folderId))
        case let .reviewCards(folderId):
            LearnCardView(store: state.reviewCards(folderId: folderId))
        case .learnFolders:
            LearnFoldersListFactory.makeView(for: state.learnFoldersListStore())
        case .editRememberItem:
            EmptyView()
        }
    }
}

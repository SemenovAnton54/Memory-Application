//
//  FoldersCoordinatorView.swift
//  Memory
//

import SwiftUI

struct FoldersCoordinatorView: View {
    @ObservedObject var state: FoldersCoordinatorState

    var body: some View {
        linkDestination(link: state.route)
            .navigationDestination(item: $state.nextItem) {
                switch $0 {
                default:
                    if let state = state.nextItemCoordinatorState(for: $0) {
                        FoldersCoordinatorFactory().makeView(for: state)
                    } else {
                        EmptyView()
                    }

                }
            }
            .sheet(item: $state.presentedItem, content: sheetContent)
    }

    @ViewBuilder func sheetContent(item: FoldersRoute) -> some View {
        switch item {
        case let .editFolder(id):
            EditFolderView(store: state.folderStore(id: id))
        case let .editWordRememberItem(id, categoriesIds):
            RememberItemCoordinatorFactory().makeView(
                for: state.rememberItemCoordinatorState(
                    router: .editWordRememberItem(
                        id: id,
                        categoriesIds: categoriesIds
                    )
                )
            )
        case let .editCategory(id, folderId):
            EditCategoryView(store: state.categoryStore(id: id, folderId: folderId))
        default:
            EmptyView()
        }
    }

    @ViewBuilder func linkDestination(link: FoldersRoute) -> some View {
        switch link {
        case .foldersList:
            FoldersListView(store: state.foldersListStore())
        case let .folderDetails(id):
            FolderDetailsView(store: state.folderDetailsStore(id: id))
        case let .categoryDetails(id):
            CategoryDetailsView(store: state.categoryDetailsStore(id: id))
        default:
            EmptyView()
        }
    }
}

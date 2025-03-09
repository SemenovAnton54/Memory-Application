//
//  LearnFoldersListView.swift
//  Memory
//

import SwiftUI
import Combine

struct LearnFoldersListView<T: StateMachine>: View where T.ViewState == LearnFoldersListViewState, T.Event == LearnFoldersListEvent {
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        List {
            Section() {
                ForEach(store.viewState.folders) { folder in
                    ItemListRow(
                        id: folder.id,
                        icon: folder.icon,
                        name: folder.name,
                        description: folder.description
                    ) {
                        store.event(.folderSelected(id: folder.id))
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listRowSeparatorTint(.white.opacity(0.1))
            .listRowBackground(Colors.backgroundSecondary)
        }
        .background(Colors.background)
        .scrollContentBackground(.hidden)
    }
}

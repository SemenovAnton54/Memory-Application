//
//  FoldersListView.swift
//  Memory
//

import SwiftUI
import Combine

struct FoldersListView<T: StateMachine>: View where T.ViewState == FoldersListViewState, T.Event == FoldersListEvent {
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        List {
            Section() {
                Button(action: { store.event(.newFolder) }) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundStyle(Colors.actionColor)
                        MainText("New folder")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .listRowInsets(EdgeInsets())
                .buttonStyle(PressButtonStyle())
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    0
                }
                .accessibilityIdentifier(FoldersListAccessibilityIdentifier.newFolderButton)

                ForEach(store.viewState.favoriteFolders) { folder in
                    FolderRow(
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
        .accessibilityIdentifier(FoldersListAccessibilityIdentifier.folderList)
        .background(Colors.background)
        .scrollContentBackground(.hidden)
        .onAppear {
            store.event(.contentAppeared)
        }
    }
}

struct FoldersListView_Previews: PreviewProvider {
    class MemorizeMockStore: StateMachine {
        @Published var viewState: FoldersListViewState

        init() {
            self.viewState = .init(
                favoriteFolders: [.init(
                    id: 1,
                    name: "English",
                    description: "Learning words of English, i want to know every word which i know",
                    isFavorite: true,
                    icon: "😆",
                    image: nil
                ),.init(
                    id: 2,
                    name: "Programming",
                    description: "Programming is the art of building software",
                    isFavorite: true,
                    icon: "😱",
                    image: nil
                ),.init(
                    id: 3,
                    name: "Programming",
                    description: "Programming is the art of building software",
                    isFavorite: true,
                    icon: "",
                    image: nil
                )]
            )
        }

        func event(_ event: FoldersListEvent) {
            print(event)
        }
    }

    static var previews: some View {
        FoldersListView(store: MemorizeMockStore())
    }
}

//
//  LearnMainView.swift
//  Memory
//

import SwiftUI
import Combine

struct LearnMainView<T: MemorizeStore>: View where T.ViewState == LearnMainViewState, T.Event == LearnMainEvent {
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        VStack {
            if store.viewState.isFoldersExists {
                List {
                    Section(header: SecondText("Favorite Folders")) {
                        if store.viewState.favoriteFolders.isEmpty {
                            MainText("No favorite folders")
                        } else {
                            ForEach(store.viewState.favoriteFolders) { folder in
                                FolderRow(
                                    icon: folder.icon,
                                    name: folder.name,
                                    description: folder.description
                                ) {
                                    store.event(.folderSelected(id: folder.id))
                                }
                                .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    .listRowSeparatorTint(.white.opacity(0.1))
                    .listRowBackground(Colors.backgroundSecondary)
                }
                .scrollContentBackground(.hidden)

                Button(action: { store.event(.showAllFolders) }) {
                    HStack {
                        MainText("Show all folders")
                    }
                }
                .buttonStyle(PressButtonStyle())
                .background(Colors.actionColor)
                .cornerRadius(12)
                .padding(.bottom, 20)
            } else {
                MainText("No folders yet")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.background)
        .onAppear {
            store.event(.onAppear)
        }
    }
}

struct LearnMainView_Previews: PreviewProvider {
    class MemorizeMockStore: MemorizeStore {
        @Published var viewState: LearnMainViewState

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
                )],
                isFoldersExists: true
            )
        }

        func event(_ event: LearnMainEvent) {
            print(event)
        }
    }

    static var previews: some View {
        LearnMainView(store: MemorizeMockStore())
    }
}

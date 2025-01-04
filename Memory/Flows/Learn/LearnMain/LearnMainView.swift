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
                                LearnMainFavoriteFolderView(
                                    favoriteFolderViewModel: folder,
                                    event: { [weak store] in
                                        store?.event($0)
                                    }
                                )
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
                favoriteFolders: [
                    .init(
                        folder: .init(
                            id: 1,
                            name: "English",
                            description: "Learning words of English, i want to know every word which i know",
                            isFavorite: true,
                            icon: "😆",
                            image: nil
                        ),
                        learnedNewItemsTodayCount: 1,
                        itemToReviewCount: 2,
                        reviewedItemsTodayCount: 3
                    ),
                    .init(
                        folder: .init(
                            id: 2,
                            name: "Programming",
                            description: "Programming is the art of building software",
                            isFavorite: true,
                            icon: "😱",
                            image: nil
                        ),
                        learnedNewItemsTodayCount: 1,
                        itemToReviewCount: 4,
                        reviewedItemsTodayCount: 2
                    ),
                    .init(
                        folder: .init(
                            id: 3,
                            name: "Programming",
                            description: "Programming is the art of building software",
                            isFavorite: true,
                            icon: "",
                            image: nil
                        ),
                        learnedNewItemsTodayCount: 5,
                        itemToReviewCount: 1,
                        reviewedItemsTodayCount: 2
                    )
                ],
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

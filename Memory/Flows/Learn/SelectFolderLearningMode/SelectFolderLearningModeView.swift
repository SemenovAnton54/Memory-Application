//
//  SelectFolderLearningModeView.swift
//  Memory
//

import SwiftUI
import Combine

struct SelectFolderLearningModeView<T: MemorizeStore>: View where T.ViewState == SelectFolderLearningModeViewState, T.Event == SelectFolderLearningModeEvent {
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            List {
                Section("Remember Items") {
                    LearnRow(
                        systemName: "plus.app",
                        imageColor: Colors.actionColor,
                        title: "Learn new items",
                        description: "Learned today: \(store.viewState.learnedNewItemsTodayCount)"
                    ) {
                        store.event(.learnNewCards)
                    }
                    .listRowInsets(EdgeInsets())

                    LearnRow(
                        systemName: "repeat.circle",
                        imageColor: Colors.actionColor,
                        title: "Review items",
                        description: "Items to review: \(store.viewState.itemToReviewCount) (reviewed today: \(store.viewState.reviewedItemsTodayCount))"
                    ) {
                        store.event(.reviewCards)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listRowSeparatorTint(.white.opacity(0.1))
                .listRowBackground(Colors.backgroundSecondary)
            }
            .background(Colors.background)
            .scrollContentBackground(.hidden)
        }
    }
}

struct SelectFolderLearningModeView_Previews: PreviewProvider {
    class MemorizeMockStore: MemorizeStore {
        @Published var viewState: SelectFolderLearningModeViewState

        init() {
            self.viewState = .init(
                learnedNewItemsTodayCount: 2,
                reviewedItemsTodayCount: 3,
                itemToReviewCount: 5
            )
        }

        func event(_ event: SelectFolderLearningModeEvent) {
            print(event)
        }
    }

    static var previews: some View {
        SelectFolderLearningModeView(store: MemorizeMockStore())
    }
}

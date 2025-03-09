//
//  CategoryDetailsView.swift
//  Memory
//

import SwiftUI
import Combine

struct CategoryDetailsView<T: StateMachine>: View where T.ViewState == CategoryDetailsViewState, T.Event == CategoryDetailsEvent {
    typealias AccessibilityIdentifier = CategoryDetailsAccessibilityIdentifier

    @ObservedObject var store: T

    @State private var showingOptions = false
    @State private var showingDeleteConfirmation = false

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            List {
                Section("Category") {
                    if let category = store.viewState.category {
                        DetailsSectionHeaderView(
                            image: category.image.flatMap { ImageViewModel(imageType: $0) },
                            name: category.name,
                            icon: category.icon,
                            description: category.description
                        )
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .listRowSeparatorTint(.white.opacity(0.1))
                .listRowBackground(Colors.backgroundSecondary)

                Section("Remember Items") {
                    ForEach(store.viewState.rememberItems) { rememberItem in
                        switch rememberItem.type {
                        case .word, .card:
                            if let word = rememberItem.word {
                                WordListView(
                                    level: rememberItem.repeatLevel,
                                    word: word.word,
                                    translation: word.translation,
                                    editAction: { [weak store] in
                                        store?.event(.editRememberItem(id: rememberItem.id))
                                    },
                                    deleteAction: { [weak store] in
                                        store?.event(.deleteRememberItem(id: rememberItem.id))
                                    }
                                )
                                .listRowInsets(EdgeInsets(top: -10, leading: 0, bottom: -10, trailing: -10))
                            }
                        }
                    }
                }
                .listRowSeparatorTint(.white.opacity(0.1))
                .listRowBackground(Colors.backgroundSecondary)
            }
            .accessibilityIdentifier(AccessibilityIdentifier.collectionView)
            .background(Colors.background)
            .scrollContentBackground(.hidden)
            .toolbar {
                Button(action: { showingOptions = true }) {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityIdentifier(AccessibilityIdentifier.options)
                .confirmationDialog("Select option", isPresented: $showingOptions, titleVisibility: .visible) {
                    Button("Edit") {
                        store.event(.editCategory)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifier.editButton)

                    Button("Delete", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                    .accessibilityIdentifier(AccessibilityIdentifier.deleteButton)
                }
                .confirmationDialog("Are you sure you want to delete?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                    Button("Yes", role: .destructive) {
                        store.event(.deleteCategory)
                    }

                    Button("No") {
                        showingDeleteConfirmation = false
                    }
                }
            }

            VStack {
                Spacer()
                Button(action: { store.event(.addRememberItem) }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                        MainText("New Remember Item")
                    }
                }
                .buttonStyle(PressButtonStyle())
                .background(Colors.actionColor)
                .cornerRadius(12)

                Spacer()
                    .frame(height: 30)
            }
        }
    }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    class MemorizeMockStore: StateMachine {
        @Published var viewState: CategoryDetailsViewState

        init() {
            self.viewState = .init(
                category: .init(
                    id: 1,
                    name: "Some name",
                    description: "Some description",
                    icon: "",
                    image: nil
                ),
                rememberItems: []
            )
        }

        func event(_ event: CategoryDetailsEvent) {
            print(event)
        }
    }

    static var previews: some View {
        CategoryDetailsView(store: MemorizeMockStore())
    }
}

//
//  FolderDetailsView.swift
//  Memory
//

import SwiftUI
import Combine

struct FolderDetailsView<T: StateMachine>: View where T.ViewState == FolderDetailsViewState, T.Event == FolderDetailsEvent {
    @ObservedObject var store: T

    @State private var showingOptions = false
    @State private var showingDeleteConfirmation = false

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            List {
                Section("Folder") {
                    if let folder = store.viewState.folder {
                        DetailsSectionHeaderView(
                            image: folder.image.flatMap { ImageViewModel(imageType: $0) },
                            name: folder.name,
                            icon: folder.icon,
                            description: folder.description
                        )
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .listRowSeparatorTint(.white.opacity(0.1))
                .listRowBackground(Colors.backgroundSecondary)

                Section(
                    content: {
                        ForEach(store.viewState.categories) { category in
                            ItemListRow(
                                id: category.id,
                                icon: category.icon,
                                name: category.name,
                                description: category.description
                            ) {
                                store.event(.categoryDetails(id: category.id))
                            }
                            .listRowInsets(EdgeInsets())
                            .accessibilityIdentifier(FolderDetailsAccessibilityIdentifier.categoryCell(id: category.id))
                        }
                    },
                    header: {
                        Text("Categories")
                    },
                    footer: {
                        Spacer(minLength: 70)
                    }
                )
                .listRowSeparatorTint(.white.opacity(0.1))
                .listRowBackground(Colors.backgroundSecondary)
            }
            .accessibilityIdentifier(FolderDetailsAccessibilityIdentifier.collectionView)
            .background(Colors.background)
            .scrollContentBackground(.hidden)
            .toolbar {
                Button(action: { showingOptions = true }) {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityIdentifier(FolderDetailsAccessibilityIdentifier.options)
                .confirmationDialog("Select option", isPresented: $showingOptions, titleVisibility: .visible) {
                    Button("Edit") {
                        store.event(.editFolder)
                    }
                    .accessibilityIdentifier(FolderDetailsAccessibilityIdentifier.editButton)

                    Button("Delete", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                    .accessibilityIdentifier(FolderDetailsAccessibilityIdentifier.deleteButton)
                }
                .confirmationDialog("Are you sure you want to delete?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                    Button("Yes", role: .destructive) {
                        store.event(.deleteFolder)
                    }

                    Button("No") {
                        showingDeleteConfirmation = false
                    }
                }
            }

            VStack {
                Spacer()
                Button(action: { store.event(.addCategory) }) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                        MainText("New Category")
                    }
                }
                .buttonStyle(PressButtonStyle())
                .background(Colors.actionColor)
                .cornerRadius(12)
                .accessibilityIdentifier(FolderDetailsAccessibilityIdentifier.addCategoryButton)

                Spacer()
                    .frame(height: 30)
            }
        }
    }
}

struct FolderDetailsView_Previews: PreviewProvider {
    class MemorizeMockStore: StateMachine {
        @Published var viewState: FolderDetailsViewState

        init() {
            self.viewState = .init(
                folder: .init(
                    id: 1,
                    name: "Name",
                    description: "Description aa eawe weaw eawe ae aweawe aeeawe awe awe awe awe awe awe awe awe awe awe awe awe awe awe awe awe w",
                    isFavorite: false,
                    icon: "😅",
                    image: nil
                ),
                categories: []
            )
        }

        func event(_ event: FolderDetailsEvent) {
            print(event)
        }
    }

    static var previews: some View {
        FolderDetailsView(store: MemorizeMockStore())
    }
}

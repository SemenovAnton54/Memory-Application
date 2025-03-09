//
//  EditCategoryView.swift
//  Memory
//

import SwiftUI
import Combine
import PhotosUI

struct EditCategoryView<T: StateMachine>: View where T.ViewState == EditCategoryViewState, T.Event == EditCategoryEvent {
    @State private var icon = ""
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    HStack {
                        Button("Cancel", action: { store.event(.cancel) })
                            .accessibilityIdentifier(EditCategoryAccessibilityIdentifier.cancelButton)
                        Spacer()
                        Button("Save", action: { store.event(.save) })
                            .accessibilityIdentifier(EditCategoryAccessibilityIdentifier.saveButton)
                    }

                    Text(store.viewState.isNewCategory ? "New Category" : "Edit category")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Colors.text)
                        .accessibilityIdentifier(EditCategoryAccessibilityIdentifier.title)
                }

                ZStack {
                    HStack {
                        Spacer()
                        if let imageViewModel = store.viewState.image {
                            SelectedImageView(
                                imageViewModel: imageViewModel,
                                deleteImageAction: {
                                    store.event(.removeImage)
                                }
                            )
                        } else {
                            PhotosPicker(
                                selection: binding(nil) { store.event(.addImage($0)) },
                                matching: .images
                            ) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .background(Colors.backgroundSecondary)
                                    .tint(Color.white)
                                    .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }
                }

                TextField(
                    "",
                    text: binding(store.viewState.title) { store.event(.nameDidChange($0)) },
                    prompt: Text("Name").foregroundStyle(Colors.textSecondary)
                )
                .defaultStyle()
                .accessibilityIdentifier(EditCategoryAccessibilityIdentifier.nameField)

                TextField(
                    "",
                    text: $icon,
                    prompt: Text("Icon (only emoji)").foregroundStyle(Colors.textSecondary)
                )
                .defaultStyle()
                .accessibilityIdentifier(EditCategoryAccessibilityIdentifier.iconField)
                .onReceive(Just(icon)) { newValue in
                    let newValue = newValue.onlyEmoji().last?.toString() ?? store.viewState.icon

                    if newValue != icon {
                        icon = newValue
                    }

                    guard newValue != store.viewState.icon else {
                        return
                    }

                    icon = newValue.onlyEmoji().last?.toString() ?? ""
                    store.event(.iconDidChanged(icon))
                }

                TextField(
                    "",
                    text: binding(store.viewState.description) { store.event(.descDidChanged($0)) },
                    prompt: Text("Description").foregroundStyle(Colors.textSecondary)
                )
                .defaultStyle()
                .accessibilityIdentifier(EditCategoryAccessibilityIdentifier.descriptionField)

                Spacer()
            }
            .padding()
        }
        .background(Colors.background)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct EditCategoryView_Previews: PreviewProvider {
    class EditCategoryMemorizeMockStore: StateMachine {
        @Published var viewState: EditCategoryViewState

        init() {
            self.viewState = .init(
                isNewCategory: true,
                title: "",
                description: "",
                icon: "",
                image: nil
            )
        }

        func event(_ event: EditCategoryEvent) {
            print(event)
        }
    }

    static var previews: some View {
        EditCategoryView(store: EditCategoryMemorizeMockStore())
    }
}

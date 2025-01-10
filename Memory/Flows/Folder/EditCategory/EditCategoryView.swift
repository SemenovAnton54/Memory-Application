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
                        Spacer()
                        Button("Save", action: { store.event(.save) })
                    }

                    Text(store.viewState.isNewCategory ? "New Category" : "Edit category")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Colors.text)
                }

                ZStack {
                    HStack {
                        Spacer()
                        PhotosPicker(
                            selection: binding(nil) { store.event(.addImage($0)) },
                            matching: .images
                        ) { [image = store.viewState.image] in
                            ImagePickerView(
                                imageViewModel: nil,
                                deleteImageAction: {
//                                    store.event(.removeImage)
                                }
                            )
                        }
                        Spacer()
                    }
                }

                TextField(
                    "",
                    text: binding(store.viewState.title) { store.event(.nameDidChange($0)) },
                    prompt: Text("Name").foregroundStyle(Colors.textSecondary)
                ).defaultStyle()

                TextField(
                    "",
                    text: $icon,
                    prompt: Text("Icon (only emoji)").foregroundStyle(Colors.textSecondary)
                ).defaultStyle()
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
                ).defaultStyle()

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

//
//  RepeatView.swift
//  Memory
//

import SwiftUI
import SwiftData
import PhotosUI
import Combine

struct EditFolderView<T: StateMachine>: View where T.ViewState == EditFolderViewState, T.Event == EditFolderEvent {
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
                        Button("Cancel") { store.event(.cancel) }
                        Spacer()
                        Button("Save") { store.event(.save) }
                    }

                    Text(store.viewState.isNewFolder ? "New Folder" : "Edit folder")
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
                        ) {
                            ZStack(alignment: .topTrailing) {
                                if let image = store.viewState.image {
                                    ImageView(imageViewModel: image)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 150)

                                    Button(action: { store.event(.removeImage) }) {
                                        ZStack {
                                            Image(systemName: "xmark.circle.fill")
                                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                                    }
                                    .frame(width: 25, height: 25)
                                    .padding(.top, -15)
                                    .padding(.trailing, -15)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .padding()
                                        .background(Colors.backgroundSecondary)
                                        .tint(Color.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        Spacer()
                    }
                }

                TextField(
                    "Name",
                    text: binding(store.viewState.title) { store.event(.nameDidChange($0)) },
                    prompt: Text("Enter Name").foregroundStyle(Colors.textSecondary)
                ).defaultStyle()

                TextField(
                    "Icon",
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
                    "Description",
                    text: binding(store.viewState.description) { store.event(.descDidChanged($0)) },
                    prompt: Text("Enter Description").foregroundStyle(Colors.textSecondary)
                ).defaultStyle()

                Toggle(
                    "Favorite",
                    isOn: binding(store.viewState.isFavorite) { store.event(.isFavoriteChanged($0)) }
                )
                .padding(15)
                .background(Colors.backgroundSecondary)
                .tint(Colors.actionColor)
                .foregroundStyle(Colors.text)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
        }
        .background(Colors.background)
    }
}

struct EditFolderView_Previews: PreviewProvider {
    class EditFolderMemorizeMockStore: StateMachine {
        @Published var viewState: EditFolderViewState

        init() {
            self.viewState = .init(
                isNewFolder: true,
                title: "",
                description: "",
                icon: "",
                isFavorite: false,
                image: nil
            )
        }

        func event(_ event: EditFolderEvent) {
            print(event)
        }
    }

    static var previews: some View {
        EditFolderView(store: EditFolderMemorizeMockStore())
    }
}

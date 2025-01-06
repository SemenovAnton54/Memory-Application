//
//  EditWordRememberItemView.swift
//  Memory
//

import SwiftUI
import Combine
import PhotosUI

struct EditWordRememberItemView<T: MemorizeStore>: View where T.ViewState == EditWordRememberItemViewState, T.Event == EditWordRememberItemEvent {
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("Cancel", action: { store.event(.cancel) })
                    Spacer()
                    Button("Save", action: { store.event(.save) })
                }

                Text(store.viewState.isNewRememberItem ? "New Word" : "EditWord")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Colors.text)
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 5)

            if !store.viewState.isLoading {
                ScrollView {
                    VStack(spacing: 20) {
                        TextField(
                            "",
                            text: binding(store.viewState.word) { store.event(.wordDidChange($0)) },
                            prompt: Text("Name").foregroundStyle(Colors.textSecondary)
                        ).defaultStyle()

                        TextField(
                            "",
                            text: binding(store.viewState.transcription) { store.event(.transcriptionDidChange($0)) },
                            prompt: Text("Transcription (optional)").foregroundStyle(Colors.textSecondary)
                        ).defaultStyle()

                        TextField(
                            "",
                            text: binding(store.viewState.translation) { store.event(.translationDidChange($0)) },
                            prompt: Text("Translation").foregroundStyle(Colors.textSecondary)
                        ).defaultStyle()

                        ZStack {
                            HStack {
                                Spacer()
                                ForEach(store.viewState.images) { image in
                                    SelectedImage(
                                        removeImage: { [weak store] in
                                            store?.event(.removeImage(id: image.id))
                                        },
                                        imageModel: image
                                    )
                                }

                                Image(systemName: "plus.app")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .foregroundStyle(Colors.actionColor)
                                    .background(Colors.backgroundSecondary)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        store.event(.addImage)
                                    }

                                Spacer()
                            }
                        }

                        ForEach(store.viewState.examples) { example in
                            ExampleView(
                                example: binding(example.example) {
                                    store.event(.exampleChanged(id: example.id, example: $0))
                                },
                                exampleTranslation: binding(example.translation) {
                                    store.event(.exampleTranslationChanged(id: example.id, translation: $0))
                                },
                                delete: { store.event(.deleteExample(id: example.id)) }
                            )
                        }

                        Button(action: { store.event(.addNewExample) }) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus")
                                Text("New example")
                                Spacer()
                            }
                            .padding()
                            .background(Colors.backgroundSecondary)
                            .foregroundStyle(Colors.text)
                            .cornerRadius(8)
                        }

                        Toggle(isOn: binding(store.viewState.isLearning) { store.event(.isLearningChanged($0)) }) {
                            HStack {
                                Text("Start learning this word")
                                    .foregroundStyle(Colors.text)
                                Spacer()
                                Image(systemName: "questionmark.circle")
                                    .foregroundStyle(Colors.text)
                            }
                        }
                        .padding()
                        .background(Colors.backgroundSecondary)
                        .cornerRadius(8)

                        Spacer()
                    }
                    .padding()
                }
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .background(Colors.background)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

extension EditWordRememberItemView {
    struct ExampleView: View {
        @Binding var example: String
        @Binding var exampleTranslation: String

        let delete: () -> Void

        var body: some View {
            ZStack(alignment: .trailing) {
                VStack {
                    TextField(
                        "",
                        text: $example,
                        prompt: Text("Example").foregroundStyle(Colors.textSecondary),
                        axis: .vertical
                    ).defaultStyle()

                    Divider()

                    TextField(
                        "",
                        text: $exampleTranslation,
                        prompt: Text("Translation").foregroundStyle(Colors.textSecondary),
                        axis: .vertical
                    ).defaultStyle()
                }
                .background(Colors.backgroundSecondary)
                .cornerRadius(8)

                VStack {
                    Button(action: delete) {
                        ZStack {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: 50, height: 50, alignment: .trailing)
                    .padding(.top, -25)
                    .padding(.trailing, -25)
                    Spacer()
                }
            }
        }
    }
}

struct EditWordRememberItemView_Previews: PreviewProvider {
    class MemorizeMockStore: MemorizeStore {
        @Published var viewState: EditWordRememberItemViewState

        init() {
            self.viewState = .init(
                isLoading: false,
                isNewRememberItem: true,
                word: "Repeat",
                translation: "Повторить",
                transcription: "frkrgo",
                images: [],
                isLearning: true,
                examples: []
            )
        }

        func event(_ event: EditWordRememberItemEvent) {
            print(event)
        }
    }

    static var previews: some View {
        EditWordRememberItemView(store: MemorizeMockStore())
    }
}

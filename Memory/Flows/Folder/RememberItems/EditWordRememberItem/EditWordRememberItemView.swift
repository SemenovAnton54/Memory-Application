//
//  EditWordRememberItemView.swift
//  Memory
//

import SwiftUI
import Combine
import PhotosUI

struct EditWordRememberItemView<T: StateMachine>: View where T.ViewState == EditWordRememberItemViewState, T.Event == EditWordRememberItemEvent {
    typealias AccessibilityIdentifier = EditWordRememberItemAccessibilityIdentifier
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("Cancel", action: { store.event(.cancel) })
                        .accessibilityIdentifier(AccessibilityIdentifier.cancelButton)
                    Spacer()
                    Button("Save", action: { store.event(.save) })
                        .accessibilityIdentifier(AccessibilityIdentifier.saveButton)
                }

                Text(store.viewState.isNewRememberItem ? "New Word" : "EditWord")
                    .accessibilityIdentifier(AccessibilityIdentifier.titleLabel)
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
                            prompt: Text("Word").foregroundStyle(Colors.textSecondary)
                        )
                        .defaultStyle()
                        .accessibilityIdentifier(AccessibilityIdentifier.wordTextField)

                        TextField(
                            "",
                            text: binding(store.viewState.transcription) { store.event(.transcriptionDidChange($0)) },
                            prompt: Text("Transcription (optional)").foregroundStyle(Colors.textSecondary)
                        )
                        .defaultStyle()
                        .accessibilityIdentifier(AccessibilityIdentifier.transcriptionTextField)

                        TextField(
                            "",
                            text: binding(store.viewState.translation) { store.event(.translationDidChange($0)) },
                            prompt: Text("Translation").foregroundStyle(Colors.textSecondary)
                        )
                        .defaultStyle()
                        .accessibilityIdentifier(AccessibilityIdentifier.translationTextField)

                        ZStack {
                            HStack {
                                Spacer()
                                ForEach(store.viewState.images) { image in
                                    SelectedImage(
                                        removeImage: { [weak store] in
                                            store?.event(.removeImage(index: image.id))
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
                                    .accessibilityIdentifier(AccessibilityIdentifier.addImageButton)

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
                        .accessibilityIdentifier(AccessibilityIdentifier.newExampleButton)

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
                        .accessibilityIdentifier(AccessibilityIdentifier.startLearnSwitcher)

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
                    exampleTextField(prompt: "Example", text: $example)
                        .accessibilityIdentifier(AccessibilityIdentifier.newExampleTextField)

                    Divider()

                    exampleTextField(prompt: "Translation", text: $exampleTranslation)
                        .accessibilityIdentifier(AccessibilityIdentifier.newExampleTranslationTextField)
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
                    .accessibilityIdentifier(AccessibilityIdentifier.deleteNewExampleTranslationButton)
                    Spacer()
                }
            }
        }

        @ViewBuilder
        func pasteClearView(text: String, action: @escaping (String) -> Void) -> some View {
            if text.isEmpty {
                ZStack {
                    HStack {
                        Spacer()
                        Button("Paste") {
                            action(UIPasteboard.general.string ?? "")
                        }
                        .padding(.trailing, 20)
                    }
                }
            } else {
                ZStack {
                    HStack {
                        Spacer()
                        Button(action: { action("") }) {
                            Image(systemName: "delete.left")
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                    }
                }
            }
        }

        func exampleTextField(prompt: String, text: Binding<String>) -> some View {
            ZStack {
                TextField(
                    "",
                    text: text,
                    prompt: Text("\(prompt)").foregroundStyle(Colors.textSecondary),
                    axis: .vertical
                )
                .defaultStyle()
                .padding(.trailing, 40)

                pasteClearView(text: text.wrappedValue) {
                    text.wrappedValue = $0
                }
            }
        }
    }
}

struct EditWordRememberItemView_Previews: PreviewProvider {
    class MemorizeMockStore: StateMachine {
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
                examples: [.init(example: "", translation: "2222")]
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

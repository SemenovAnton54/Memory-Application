//
//  LearnCardView.swift
//  Memory
//

import SwiftUI
import Combine

struct LearnCardView<T: MemorizeStore>: View where T.ViewState == LearnCardViewState, T.Event == LearnCardEvent {
    @State private var keyboardHeight: CGFloat = 0
    @State var cardXOffset: CGFloat = 0
    @State var notRememberedItem = false
    @State var cardOpacityEffect: CGFloat = 1
    @State var cardScaleEffect: CGFloat = 1
    @State var showAnimation: Bool = false

    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack() {
            ZStack() {
                ZStack {
                    if store.viewState.isLoading || showAnimation {
                        Spacer()
                    } else if let state = store.viewState.wordCardViewState {
                        ZStack {
                            ScrollView {
                                Header(
                                    color: store.viewState.rememberItemViewModel?.repeatLevel.color ?? .gray,
                                    title: store.viewState.rememberItemViewModel?.repeatLevel.title ?? "",
                                    editAction: { store.event(.editCard) }
                                )
                                .padding(.horizontal, 20)

                                LearnNewWortTypeItemView(
                                    isImagesHidden: state.isImagesHidden,
                                    actionStyle: state.actionStyle,
                                    enteringWord: state.enteringWord,
                                    wrongAnswersCount: state.wrongAnswersCount,
                                    wordViewModel: state.word,
                                    onEvent: { [weak store] in
                                        store?.event(.wordCardEvent($0))
                                    }
                                )
                                .padding(.bottom, keyboardHeight)

                                Spacer(minLength: 70)
                            }
                            .scrollIndicators(.hidden)
                            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])

                            Bottom(
                                rememberAction: {
                                    swipeAnimation(offset: -500)
                                },
                                repeatAction: {
                                    swipeAnimation(offset: 500)
                                }
                            )
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.horizontal, 20)
                        }
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.2)) {
                                cardScaleEffect = 1
                                cardOpacityEffect = 1
                            }
                        }
                    } else {
                        Text("No words")
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.backgroundSecondary)
            )
            .cornerRadius(20)
            .overlay(
                CorrectAnswerRoundedRectangle(
                    actionStyle: store.viewState.wordCardViewState?.actionStyle ?? .buttons,
                    animationCompleted: { store.event(.wordCardEvent(.correctAnswerAnimationFinished)) }
                )
            )
            .padding(EdgeInsets(horizontal: 20))
            .scaleEffect(cardScaleEffect)
            .offset(x: cardXOffset)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard)
        .background(Colors.background)
        .opacity(cardOpacityEffect)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .onReceive(store.objectWillChange) { _ in
            guard showAnimation else {
                return
            }

            withAnimation {
                showAnimation = false
            }
        }
    }

    func swipeAnimation(offset: CGFloat) {
        withAnimation(.easeIn(duration: 0.2)) {
            cardXOffset = offset
        } completion: {
            showAnimation = true
        }

        withAnimation(.easeIn(duration: 0.05).delay(0.2)) {
            cardScaleEffect = 0.7
            cardOpacityEffect = 0
        } completion: {
            cardXOffset = 0
            store.event(.remember)
        }
    }
}

struct LearnNewItemView_Previews: PreviewProvider {
    class MemorizeMockStore: MemorizeStore {
        @Published var viewState: LearnCardViewState

        init() {
            self.viewState = .init(
                isLoading: false,
                wordCardViewState: .init(
                    word: .init(
                        id: 2,
                        word: "Word",
                        transcription: "fkfkf",
                        translation: "Слово",
                        examples: [.init(example: "What is your name?", translation: "Как тебя зовут?")],
                        images: []
                    ),
                    isImagesHidden: false,
                    actionStyle: .textField,
                    enteringWord: "111",
                    wrongAnswersCount: 1
                ),
                rememberItemViewModel: .init(
                    id: 1,
                    categoryIds: [1, 2],
                    type: .word,
                    repeatLevel: .first,
                    createdAt: Date(),
                    updatedAt: nil,
                    levelChangedAt: nil,
                    word: .init(
                        id: 2,
                        word: "Word",
                        transcription: "fkfkf",
                        translation: "Слово",
                        examples: [.init(example: "What is your name?", translation: "Как тебя зовут?")],
                        images: []
                    )
                )
            )
        }

        func event(_ event: LearnCardEvent) {
            print(event)
        }
    }

    static var previews: some View {
        LearnCardView(store: MemorizeMockStore())
    }
}

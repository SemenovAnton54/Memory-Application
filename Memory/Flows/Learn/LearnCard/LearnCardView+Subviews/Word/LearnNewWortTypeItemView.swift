//
//  LearnNewWortTypeItem.swift
//  Memory
//

import SwiftUI
import Foundation

struct LearnNewWortTypeItemView: View {
    let isImagesHidden: Bool
    let actionStyle: LearnCardState.WordCardState.ActionStyle
    let enteringWord: String
    let wrongAnswersCount: Int
    let wordViewModel: WordViewModel
    let onEvent: (LearnCardEvent.WordCardEvent) -> ()

    init(
        isImagesHidden: Bool,
        actionStyle: LearnCardState.WordCardState.ActionStyle,
        enteringWord: String,
        wrongAnswersCount: Int,
        wordViewModel: WordViewModel,
        onEvent: @escaping (LearnCardEvent.WordCardEvent) -> Void
    ) {
        self.isImagesHidden = isImagesHidden
        self.actionStyle = actionStyle
        self.enteringWord = enteringWord
        self.wrongAnswersCount = wrongAnswersCount
        self.wordViewModel = wordViewModel
        self.onEvent = onEvent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderText(wordViewModel.translation)
                .padding(.horizontal, 20)

            if !isImagesHidden, !wordViewModel.images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(wordViewModel.images) {
                            ImageView(imageObject: $0)
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(12)
                                .padding(.top, 10)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Divider()
                .frame(height: 1)
                .padding(.top, 10)

            HStack {
                HeaderText(wordViewModel.word)
                Spacer()
            }
            .overlay {
                if actionStyle != .answer {
                    Rectangle().fill(Colors.actionColor).cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            if !wordViewModel.transcription.isEmpty || actionStyle != .answer  {
                HStack {
                    Text(wordViewModel.transcription)
                        .foregroundColor(.white)
                        .font(.callout)
                    Spacer()
                }
                .overlay {
                    if actionStyle != .answer {
                        Rectangle().fill(Colors.actionColor).cornerRadius(12)
                    }
                }
                .padding(.top, 2)
                .padding(.horizontal, 20)
            }

            if actionStyle != .answer {
                ActionStyleButtonView(
                    style: actionStyle == .buttons ? .large : .small,
                    changeActionStyle: { onEvent(.changeActionStyle($0)) },
                    showWord: { onEvent(.changeActionStyle(.answer)) }
                )
                .padding(.top, 10)
                .padding(.horizontal, 20)
            }

            ActionStyleView(
                actionStyle: actionStyle,
                onEvent: onEvent,
                enteringWord: enteringWord,
                wrongAnswersCount: wrongAnswersCount,
                wordViewModel: wordViewModel,
                isCorrectAnswerAnimation: false
            )
        }
    }
}

struct CheckAnswerButton: ViewModifier {
    let isHidden: Bool
    let enter: () -> Void

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !isHidden {
                Button(action: enter) {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(Colors.actionColor)
                        .padding(.trailing, 15)
                        .padding(.vertical, 15)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}


#Preview {
    LearnNewWortTypeItemView(
        isImagesHidden: true,
        actionStyle: .textField,
        enteringWord: "123",
        wrongAnswersCount: 2,
        wordViewModel: .init(
            id: 2,
            word: "Word",
            transcription: "fkfkf",
            translation: "Слово",
            examples: [.init(example: "What is your name?", translation: "Как тебя зовут?")],
            images: []
        ),
        onEvent: { _ in }
    )
    .background(
        RoundedRectangle(cornerRadius: 8)
            .fill(Colors.backgroundSecondary)
    )
    .cornerRadius(20)
    .padding(.init(top: 20, leading: 20, bottom: 0, trailing: 20))
    .background(Colors.background)
}


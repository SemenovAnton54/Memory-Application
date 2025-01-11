//
//  LearnCardView+Subviews.swift
//  Memory
//

import Foundation
import SwiftUI

extension LearnNewWortTypeItemView {
    struct ActionStyleButtonView: View {
        enum ButtonStyle {
            case small, large

            var aspectRatio: CGFloat {
                switch self {
                case .small:
                    3
                case .large:
                    1
                }
            }
        }

        let style: ButtonStyle
        let changeActionStyle: (LearnCardState.WordCardState.ActionStyle) -> ()
        let showWord: () -> ()

        var body: some View {
            HStack(spacing: 20) {
                ZStack {
                    Rectangle()
                        .aspectRatio(style.aspectRatio, contentMode: .fit)
                        .foregroundStyle(.clear)
                    Button(
                        action: { changeActionStyle(.textField) },
                        label: { Image(systemName: "keyboard") }
                    )
                    .buttonStyle(ActionButton())
                }

                Button(
                    action: { showWord() },
                    label: { Image(systemName: "eye") }
                )
                .buttonStyle(ActionButton())

                Button(
                    action: { changeActionStyle(.variants) },
                    label: { Image(systemName: "checklist") }
                )
                .buttonStyle(ActionButton())
            }
        }
    }

    struct ActionStyleWordExamplesView: View {
        @State private var expandedExamples: Set<WordExampleModel> = []

        let examples: [WordExampleModel]
        let playExample: (WordExampleModel) -> ()

        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(examples) { example in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            if !example.translation.isEmpty {
                                Button(
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            expandedExamples.toggleExistence(of: example)
                                        }
                                    },
                                    label: {
                                        Image(systemName: expandedExamples.contains(example) ? "chevron.up" : "chevron.down")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12)
                                            .foregroundStyle(Colors.actionColor)
                                    }
                                )
                            } else {
                                Spacer()
                                    .frame(width: 25)
                            }

                            Text(example.example)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(Colors.text)
                            Spacer(minLength: 20)

                            Image(systemName: "play.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                                .foregroundStyle(Colors.actionColor)
                        }
                        
                        if !example.translation.isEmpty, expandedExamples.contains(example) {
                            Text(example.translation)
                                .font(.footnote)
                                .foregroundStyle(Colors.text)
                                .padding(.horizontal, 25)
                        }
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        playExample(example)
                    }
                    .onLongPressGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            expandedExamples.toggleExistence(of: example)
                        }
                    }

                    if example != examples.last {
                        Divider()
                    }
                }
            }
        }
    }

    struct ActionStyleView: View {
        enum Field: Hashable {
            case myField
        }

        @State var isShowCorrectAnswerAnimation: Bool = false
        @State var shakeTextField: Bool = false

        @FocusState private var focusedField: Field?

        let actionStyle: LearnCardState.WordCardState.ActionStyle
        let onEvent: (LearnCardEvent.WordCardEvent) -> ()
        let enteringWord: String
        let wrongAnswersCount: Int
        let wordViewModel: WordViewModel
        let isCorrectAnswerAnimation: Bool

        let passwordFieldDelegate = TextFieldDelegate()

        var body: some View {
            switch actionStyle {
            case .buttons:
                Spacer()
            case .textField:
                TextField(
                    "Word",
                    text: binding(enteringWord) { onEvent(.enteringWord($0)) },
                    prompt: Text("Enter word").foregroundStyle(Colors.textSecondary)
                )
                .offset(x: shakeTextField ? -10 : 0)
                .focusablePadding()
                .background(isShowCorrectAnswerAnimation ? Colors.correctAnswerAnimation : Colors.backgroundSecondary)
                .foregroundStyle(Colors.text)
                .lineLimit(10)
                .font(.callout)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isShowCorrectAnswerAnimation
                            ? Colors.correctAnswerAnimation
                            : Colors.itemBackgroundSecondary,
                            lineWidth: 2
                        )
                )
                .padding(.horizontal, 1)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .introspect(.textField, on: .iOS(.v17, .v18)) {
                    passwordFieldDelegate.shouldReturn = {
                        onEvent(.checkAnswer)

                        return false
                    }

                    $0.delegate = passwordFieldDelegate
                }
                .focused($focusedField, equals: .myField)
                .modifier(CheckAnswerButton(isHidden: isCorrectAnswerAnimation, enter: { onEvent(.checkAnswer) }))
                .padding(.top, 30)
                .padding(.horizontal, 20)
                .onAppear {
                    guard !isCorrectAnswerAnimation else {
                        withAnimation(.easeInOut(duration: 0.7)) {
                            isShowCorrectAnswerAnimation = true
                        }
                        return
                    }

                    guard actionStyle == .textField else {
                        return
                    }

                    focusedField = .myField
                }
                .onChange(of: wrongAnswersCount, initial: false) { newValue, _ in
                    withAnimation(.easeInOut(duration: 0.5).repeatCount(4, autoreverses: true).speed(8)) {
                        shakeTextField = true
                    } completion: {
                        shakeTextField = false
                    }
                }

                HStack {
                    Button(action: { onEvent(.addNextLetter) }) {
                        Text("Hint (add symbol)")
                            .padding(.vertical, 10)
                    }
                    .foregroundStyle(Colors.actionColor)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Wrong answers: \(wrongAnswersCount)")
                        .foregroundStyle(Colors.textSecondary)
                        .font(.footnote)
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
            case .answer:
                ActionStyleWordExamplesView(
                    examples: wordViewModel.examples,
                    playExample: { onEvent(.playExample($0)) }
                )
                .padding(.top, 20)
            case .variants:
                ActionStyleWordExamplesView(
                    examples: wordViewModel.examples.map {
                        var example = $0
                        example.example = example.example.replacingOccurrences(of: wordViewModel.word, with: "(****)")
                        return example
                    },
                    playExample: { onEvent(.playExample($0)) }
                )
                .padding(.top, 20)
                .padding(.horizontal, 20)
            case let .correctAnswerAnimation(from: actionStyle):
                ActionStyleView(
                    actionStyle: actionStyle,
                    onEvent: onEvent,
                    enteringWord: enteringWord,
                    wrongAnswersCount: wrongAnswersCount,
                    wordViewModel: wordViewModel,
                    isCorrectAnswerAnimation: true
                )
            }
        }
    }
}

#Preview {
    let examples: [WordExampleModel] = [WordExampleModel(example: "Text example 1 ", translation: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")]
    return LearnNewWortTypeItemView.ActionStyleWordExamplesView(
        examples: examples,
        playExample: { _ in }
    )
    .background(Color.black)
}

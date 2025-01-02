//
//  EditWordRememberItemReducer.swift
//  Memory
//

import Foundation
import SwiftUI
import PhotosUI

struct EditWordRememberItemReducer {
    typealias LoadImageRequest = EditWordRememberItemState.LoadImageRequest

    func reduce(state: inout EditWordRememberItemState, event: EditWordRememberItemEvent) {
        switch event {
        case .save:
            onSave(state: &state)
        case let .itemUpdated(result):
            onItemUpdated(result: result, state: &state)
        case .cancel:
            onCancel(state: &state)
        case .addNewExample:
            onAddNewExample(state: &state)
        case let .wordDidChange(word):
            onWordDidChange(word: word, state: &state)
        case let .translationDidChange(translation):
            onTranslationDidChange(translation: translation, state: &state)
        case let .transcriptionDidChange(transcription):
            onTranscriptionDidChange(transcription: transcription, state: &state)
        case let .exampleChanged(id, example):
            onExampleChanged(id: id, example: example, state: &state)
        case let .exampleTranslationChanged(id, translation):
            onExampleTranslationChanged(id: id, translation: translation, state: &state)
        case let .deleteExample(id):
            onDeleteExample(id: id, state: &state)
        case let .addImage(item):
            onAddImage(item: item, state: &state)
        case let .imageLoaded(result):
            onImageLoaded(result: result, state: &state)
        case let .removeImage(id):
            onRemoveImage(id: id, state: &state)
        case let .itemFetched(result):
            onItemFetched(result: result, state: &state)
        case let .isLearningChanged(value):
            onIsLearningChanged(value: value, state: &state)
        case let .itemCreated(result):
            onItemCreated(result: result, state: &state)
        }
    }
}

// MARK: - Event handlers

private extension EditWordRememberItemReducer {
    func onCancel(state: inout EditWordRememberItemState) {
        state.requestRoute {
            $0.close()
        }
    }
    
    func onSave(state: inout EditWordRememberItemState) {
        guard !state.word.isEmpty else {
            return
        }

        guard let id = state.rememberItem?.id else {
            state.createRequest = FeedbackRequest(
                NewRememberItemModel(
                    categoryIds: state.categoriesIds,
                    type: .word,
                    repeatLevel: .newItem,
                    word: NewWordModel(
                        word: state.word,
                        repeatLevel: .newItem,
                        translation: state.translation,
                        transcription: state.transcription,
                        images: state.images,
                        examples: state.examples.filter { !$0.example.isEmpty }
                    )
                )
            )

            return
        }

        state.updateRequest = FeedbackRequest(
            UpdateRememberItemModel(
                id: id,
                categoryIds: state.categoriesIds,
                type: .word,
                word: UpdateWordModel(
                    id: id,
                    word: state.word,
                    translation: state.translation,
                    transcription: state.transcription,
                    images: state.images,
                    examples: state.examples.filter { !$0.example.isEmpty }
                )
            )
        )
    }

    func onItemUpdated(result: Result<RememberCardItemModel, Error>, state: inout EditWordRememberItemState) {
        state.updateRequest = nil

        switch result {
        case .success:
            state.requestRoute {
                $0.close()
            }
        case .failure:
            break
        }
    }

    func onItemCreated(result: Result<RememberCardItemModel, Error>, state: inout EditWordRememberItemState) {
        state.createRequest = nil

        switch result {
        case .success:
            state.requestRoute {
                $0.close()
            }
        case .failure:
            break
        }
    }

    func onAddNewExample(state: inout EditWordRememberItemState) {
        state.examples.append(WordExampleModel(example: "", translation: ""))
    }

    func onWordDidChange(word: String, state: inout EditWordRememberItemState) {
        state.word = word
    }

    func onTranslationDidChange(translation: String, state: inout EditWordRememberItemState) {
        state.translation = translation
    }

    func onTranscriptionDidChange(transcription: String, state: inout EditWordRememberItemState) {
        state.transcription = transcription
    }

    func onIsLearningChanged(value: Bool, state: inout EditWordRememberItemState) {
        state.isLearning = value
    }

    func onExampleChanged(id: UUID, example: String, state: inout EditWordRememberItemState) {
        guard let index = state.examples.firstIndex(where: { $0.id == id }) else {
            return
        }

        state.examples[index].example = example
    }

    func onExampleTranslationChanged(id: UUID, translation: String, state: inout EditWordRememberItemState) {
        guard let index = state.examples.firstIndex(where: { $0.id == id }) else {
            return
        }

        state.examples[index].translation = translation
    }

    func onDeleteExample(id: UUID, state: inout EditWordRememberItemState) {
        state.examples.removeAll(where: { $0.id == id })
    }

    func onAddImage(item: PhotosPickerItem?, state: inout EditWordRememberItemState) {
        guard let item else {
            return
        }

        state.loadImageRequest = FeedbackRequest(LoadImageRequest(loadImageRequest: item))
    }

    func onImageLoaded(result: Result<Data, Error>, state: inout EditWordRememberItemState) {
        state.loadImageRequest = nil

        switch result {
        case let .success(data):
            state.images.append(.data(data))
        case .failure:
            break
        }
    }

    func onRemoveImage(id: Int, state: inout EditWordRememberItemState) {
        guard id < state.images.count else {
            return
        }

        state.images.remove(at: id)
    }

    func onItemFetched(result: Result<RememberCardItemModel, Error>, state: inout EditWordRememberItemState) {
        state.fetchRequest = nil

        switch result {
        case let .success(rememberItem):
            state.rememberItem = rememberItem

            guard let wordModel = rememberItem.word else {
                return
            }

            state.word = wordModel.word
            state.transcription = wordModel.transcription
            state.translation = wordModel.translation
            state.examples = wordModel.examples
            state.images = wordModel.images
        case .failure:
            break
        }
    }
}

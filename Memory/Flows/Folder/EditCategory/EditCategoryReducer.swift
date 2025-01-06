//
//  EditCategoryReducer.swift
//  Memory
//

import SwiftUI
import PhotosUI

struct EditCategoryReducer {
    func reduce(state: inout EditCategoryState, event: EditCategoryEvent) {
        switch event {
        case let .nameDidChange(title):
            onNameDidChange(title, state: &state)
        case let .descDidChanged(description):
            onDescDidChange(description, state: &state)
        case let .iconDidChanged(icon):
            onIconDidChange(icon, state: &state)
        case let .addImage(image):
            onAddImage(image, state: &state)
        case .removeImage:
            onRemoveImage(state: &state)
        case let .imageLoaded(result):
            onImageLoaded(result, state: &state)
        case let .categoryFetched(result):
            onCategoryFetched(result, state: &state)
        case let .categoryCreated(result):
            onCategoryCreated(result, state: &state)
        case let .categoryUpdated(result):
            onCategoryUpdated(result, state: &state)
        case .cancel:
            onCancel(state: &state)
        case .save:
            onSave(state: &state)
        }
    }
}

extension EditCategoryReducer {
    func onNameDidChange(_ title: String, state: inout EditCategoryState) {
        state.name = title
    }

    func onDescDidChange(_ description: String, state: inout EditCategoryState) {
        state.description = description
    }

    func onIconDidChange(_ icon: String, state: inout EditCategoryState) {
        state.icon = icon.onlyEmoji().last?.toString() ?? ""
    }

    func onRemoveImage(state: inout EditCategoryState) {
        state.image = nil
    }

    func onAddImage(_ image: PhotosPickerItem?, state: inout EditCategoryState) {
        guard let image else {
            return
        }

        state.loadImageRequest = FeedbackRequest(image)
    }

    func onImageLoaded(_ result: Result<Data, Error>, state: inout EditCategoryState) {
        state.loadImageRequest = nil

        switch result {
        case .success(let data):
            state.image = .data(data)
        case let .failure(error):
            break
        }
    }

    func onCategoryFetched(_ result: Result<CategoryModel, Error>, state: inout EditCategoryState) {
        state.fetchCategoryRequest = nil

        switch result {
        case .success(let model):
            state.name = model.name
            state.description = model.desc ?? ""
            state.icon = model.icon ?? ""
            state.folderId = model.folderId
            state.image = model.image
        case let .failure(error):
            break
        }
    }

    func onCategoryCreated(_ result: Result<CategoryModel, Error>, state: inout EditCategoryState) {
        state.createNewCategoryRequest = nil

        switch result {
        case .success(let model):
            state.id = model.id
            state.name = model.name
            state.description = model.desc ?? ""
            state.icon = model.icon ?? ""
            state.image = model.image

            state.requestRoute {
                $0.close()
            }
        case let .failure(error):
            break
        }
    }

    func onCategoryUpdated(_ result: Result<CategoryModel, Error>, state: inout EditCategoryState) {
        state.updateCategoryRequest = nil

        switch result {
        case .success(let model):
            state.name = model.name
            state.description = model.desc ?? ""
            state.icon = model.icon ?? ""
            state.image = model.image
            state.folderId = model.folderId
            state.requestRoute {
                $0.close()
            }

        case let .failure(error):
            break
        }
    }

    func onCancel(state: inout EditCategoryState) {
        state.requestRoute {
            $0.close()
        }
    }

    func onSave(state: inout EditCategoryState) {
        guard let id = state.id else {
            guard let newModel = NewCategoryModel(
                folderId: state.folderId,
                name: state.name,
                desc: state.description,
                icon: state.icon,
                image: state.image
            ) else {
                return
            }

            state.createNewCategoryRequest = FeedbackRequest(newModel)
            return
        }

        guard let updateModel = UpdateCategoryModel(
            id: id,
            folderId: state.folderId,
            name: state.name,
            desc: state.description,
            icon: state.icon,
            image: state.image
        ) else {
            return
        }

        state.updateCategoryRequest = FeedbackRequest(updateModel)
    }
}

//
//  EditFolderReducer.swift
//  Memory
//

import Foundation
import PhotosUI
import SwiftUI

struct EditFolderReducer {
    func reduce(state: inout EditFolderState, event: EditFolderEvent) {
        switch event {
        case let .nameDidChange(title):
            onNameDidChange(title, state: &state)
        case let .descDidChanged(description):
            onDescDidChange(description, state: &state)
        case let .iconDidChanged(icon):
            onIconDidChange(icon, state: &state)
        case let .isFavoriteChanged(isFavorite):
            onIsFavorite(isFavorite, state: &state)
        case let .addImage(image):
            onAddImage(image, state: &state)
        case .removeImage:
            onRemoveImage(state: &state)
        case let .imageLoaded(result):
            onImageLoaded(result, state: &state)
        case let .folderFetched(result):
            onFolderFetched(result, state: &state)
        case let .folderCreated(result):
            onFolderCreated(result, state: &state)
        case let .folderUpdated(result):
            onFolderUpdated(result, state: &state)
        case .cancel:
            onCancel(state: &state)
        case .save:
            onSave(state: &state)
        }
    }
}

extension EditFolderReducer {
    func onNameDidChange(_ title: String, state: inout EditFolderState) {
        state.name = title
    }
    
    func onDescDidChange(_ description: String, state: inout EditFolderState) {
        state.description = description
    }

    func onIconDidChange(_ icon: String, state: inout EditFolderState) {
        state.icon = icon.onlyEmoji().last?.toString() ?? ""
    }

    func onIsFavorite(_ isFavorite: Bool, state: inout EditFolderState) {
        state.isFavorite = isFavorite
    }

    func onRemoveImage(state: inout EditFolderState) {
        state.image = nil
    }

    func onAddImage(_ image: PhotosPickerItem?, state: inout EditFolderState) {
        guard let image else {
            return
        }

        state.loadImageRequest = FeedbackRequest(image)
    }

    func onImageLoaded(_ result: Result<Data, Error>, state: inout EditFolderState) {
        state.loadImageRequest = nil

        switch result {
        case .success(let data):
            state.image = .data(data)
        case let .failure(error):
            break
        }
    }

    func onFolderFetched(_ result: Result<FolderModel, Error>, state: inout EditFolderState) {
        state.fetchFolderRequest = nil

        switch result {
        case .success(let model):
            state.name = model.name
            state.description = model.desc ?? ""
            state.isFavorite = model.isFavorite
            state.icon = model.icon ?? ""
            state.image = model.image
        case let .failure(error):
            break
        }
    }

    func onFolderCreated(_ result: Result<FolderModel, Error>, state: inout EditFolderState) {
        state.createNewFolderRequest = nil

        switch result {
        case .success(let model):
            state.id = model.id
            state.name = model.name
            state.description = model.desc ?? ""
            state.isFavorite = model.isFavorite
            state.icon = model.icon ?? ""
            state.image = model.image
        case let .failure(error):
            break
        }

        state.requestRoute {
            $0.close()
        }
    }

    func onFolderUpdated(_ result: Result<FolderModel, Error>, state: inout EditFolderState) {
        state.updateFolderRequest = nil

        switch result {
        case .success(let model):
            state.name = model.name
            state.description = model.desc ?? ""
            state.isFavorite = model.isFavorite
            state.icon = model.icon ?? ""
            state.image = model.image
            state.requestRoute {
                $0.close()
            }
            
        case let .failure(error):
            break
        }

        state.requestRoute {
            $0.close()
        }
    }

    func onCancel(state: inout EditFolderState) {
        state.requestRoute {
            $0.close()
        }
    }

    func onSave(state: inout EditFolderState) {
        guard let id = state.id else {
            guard let newModel = NewFolderModel(
                name: state.name,
                desc: state.description,
                isFavorite: state.isFavorite,
                icon: state.icon,
                image: state.image
            ) else {
                return
            }

            state.createNewFolderRequest = .init(newModel)
            return
        }

        guard let updateModel = UpdateFolderModel(
            id: id,
            name: state.name,
            desc: state.description,
            isFavorite: state.isFavorite,
            icon: state.icon,
            image: state.image
        ) else {
            return
        }

        state.updateFolderRequest = .init(updateModel)
    }
}

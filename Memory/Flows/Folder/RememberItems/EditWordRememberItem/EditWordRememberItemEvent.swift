//
//  EditWordRememberItemEvent.swift
//  Memory
//

import PhotosUI
import SwiftUI
import Foundation

enum EditWordRememberItemEvent {
    case wordDidChange(String)
    case translationDidChange(String)
    case transcriptionDidChange(String)
    case isLearningChanged(Bool)

    case addNewExample
    case deleteExample(id: UUID)
    case exampleChanged(id: UUID, example: String)
    case exampleTranslationChanged(id: UUID, translation: String)

    case addImage
    case removeImage(index: Int)
    case imagesSelected([ImageType])

    case cancel
    case save

    case itemCreated(Result<RememberCardItemModel, Error>)
    case itemFetched(Result<RememberCardItemModel, Error>)
    case itemUpdated(Result<RememberCardItemModel, Error>)
}

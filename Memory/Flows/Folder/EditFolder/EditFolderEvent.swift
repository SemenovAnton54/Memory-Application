//
//  LearnEvent.swift
//  Memory
//

import Foundation
import PhotosUI
import SwiftUI

enum EditFolderEvent {
    case nameDidChange(String)
    case descDidChanged(String)
    case iconDidChanged(String)
    case isFavoriteChanged(Bool)

    case addImage(PhotosPickerItem?)
    case removeImage
    case imageLoaded(Result<Data, Error>)

    case folderFetched(Result<FolderModel, Error>)
    case folderCreated(Result<FolderModel, Error>)
    case folderUpdated(Result<FolderModel, Error>)

    case cancel
    case save
}

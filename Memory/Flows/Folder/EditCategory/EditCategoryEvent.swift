//
//  EditCategoryEvent.swift
//  Memory
//

import Foundation
import PhotosUI
import SwiftUI

enum EditCategoryEvent {
    case nameDidChange(String)
    case descDidChanged(String)
    case iconDidChanged(String)

    case addImage(PhotosPickerItem?)
    case removeImage
    case imageLoaded(Result<Data, Error>)

    case categoryFetched(Result<CategoryModel, Error>)
    case categoryCreated(Result<CategoryModel, Error>)
    case categoryUpdated(Result<CategoryModel, Error>)

    case cancel
    case save
}

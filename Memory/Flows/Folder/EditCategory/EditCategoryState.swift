//
//  EditCategoryState.swift
//  Memory
//

import Foundation
import PhotosUI
import SwiftUI

struct EditCategoryState {
    var folderId: Int?
    var id: Int?
    var name: String = ""
    var description: String = ""
    var icon: String = ""
    var image: ImageType?

    var fetchCategoryRequest: FeedbackRequest<Int>?
    var createNewCategoryRequest: FeedbackRequest<NewCategoryModel>?
    var updateCategoryRequest: FeedbackRequest<UpdateCategoryModel>?
    var loadImageRequest: FeedbackRequest<PhotosPickerItem>?
    var routingRequest: RoutingFeedbackRequest<EditCategoryRouterProtocol, EditCategoryEvent>?
}

extension EditCategoryState: RoutingStateProtocol {}

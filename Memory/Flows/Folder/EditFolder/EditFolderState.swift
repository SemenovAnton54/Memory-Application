//
//  LearnState.swift
//  Memory
//

import Foundation
import PhotosUI
import SwiftUI

struct EditFolderState {
    var id: Int?
    var name: String = ""
    var description: String = ""
    var icon: String = ""
    var isFavorite: Bool = false
    var image: ImageType?

    var fetchFolderRequest: FeedbackRequest<Int>?
    var createNewFolderRequest: FeedbackRequest<NewFolderModel>?
    var updateFolderRequest: FeedbackRequest<UpdateFolderModel>?
    var loadImageRequest: FeedbackRequest<PhotosPickerItem>?
    var routingRequest: RoutingFeedbackRequest<EditFolderRouterProtocol, EditFolderEvent>?
}

extension EditFolderState: RoutingStateProtocol { }

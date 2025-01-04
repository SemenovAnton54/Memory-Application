//
//  FavoriteFolderViewModel.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

struct FavoriteFolderViewModel: Identifiable {
    var id: Int {
        folder.id
    }

    let folder: FolderViewModel
    let learnedNewItemsTodayCount: Int
    let itemToReviewCount: Int
    let reviewedItemsTodayCount: Int
}

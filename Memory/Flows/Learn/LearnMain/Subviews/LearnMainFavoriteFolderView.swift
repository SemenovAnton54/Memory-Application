//
//  LearnMainFavoriteFolderView.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI

struct LearnMainFavoriteFolderView: View {
    let favoriteFolderViewModel: FavoriteFolderViewModel
    let event: (LearnMainEvent) -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                FolderRow(
                    id: favoriteFolderViewModel.folder.id,
                    icon: favoriteFolderViewModel.folder.icon,
                    name: favoriteFolderViewModel.folder.name,
                    description: favoriteFolderViewModel.folder.description
                ) {
                    event(.folderSelected(id: favoriteFolderViewModel.folder.id))
                }
                
                LearnRow(
                    imageSystemName: "plus.app",
                    imageColor: Colors.actionColor,
                    title: "Learn new items",
                    description: "Learned today: \(favoriteFolderViewModel.learnedNewItemsTodayCount)"
                ) {
                    event(.learnNewItems(folderId: favoriteFolderViewModel.folder.id))
                }
                
                LearnRow(
                    imageSystemName: "repeat.circle",
                    imageColor: Colors.actionColor,
                    title: "Review items",
                    description: "Items to review: \(favoriteFolderViewModel.itemToReviewCount) (reviewed today: \(favoriteFolderViewModel.reviewedItemsTodayCount))"
                ) {
                    event(.reviewItems(folderId: favoriteFolderViewModel.folder.id))
                }
            }
        }
    }
}

extension LearnMainFavoriteFolderView {
    struct LearnRow: View {
        let imageSystemName: String
        let imageColor: Color
        let title: String
        let description: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack(spacing: 20) {
                    Image(systemName: imageSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(width: 20)
                        .foregroundStyle(imageColor)

                    VStack(alignment: .leading, spacing: 5) {
                        MainText(title)
                        SecondText(description)
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                .padding(.leading, 40)
            }
            .buttonStyle(PressButtonStyleWithCustomPadding(padding: 10))
        }
    }
}

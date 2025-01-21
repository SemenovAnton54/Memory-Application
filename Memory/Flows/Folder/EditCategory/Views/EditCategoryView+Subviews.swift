//
//  EditCategoryView+Subviews.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

import SwiftUI

extension EditCategoryView {
    struct SelectedImageView: View {
        let imageViewModel: ImageViewModel
        let deleteImageAction: () -> Void

        init(imageViewModel: ImageViewModel, deleteImageAction: @escaping () -> Void) {
            self.imageViewModel = imageViewModel
            self.deleteImageAction = deleteImageAction
        }
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                ImageView(imageViewModel: imageViewModel)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 150)

                Button(action: { deleteImageAction() }) {
                    ZStack {
                        Image(systemName: "xmark.circle.fill")
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: 25, height: 25)
                .padding(.top, -15)
                .padding(.trailing, -15)
            }
        }
    }
}

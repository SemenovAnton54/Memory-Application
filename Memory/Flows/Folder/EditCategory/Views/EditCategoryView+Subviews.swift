//
//  EditCategoryView+Subviews.swift
//  Memory
//
//  Created by Anton Semenov on 07.01.2025.
//

import SwiftUI

extension EditCategoryView {
    struct ImagePickerView: View {
        let imageViewModel: ImageViewModel?
        let deleteImageAction: () -> Void

        @MainActor
        init(imageViewModel: ImageViewModel?, deleteImageAction: @MainActor @escaping () -> Void) {
            self.imageViewModel = imageViewModel
            self.deleteImageAction = deleteImageAction
        }
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                if let image = imageViewModel {
                    ImageView(imageViewModel: image)
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
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Colors.backgroundSecondary)
                        .tint(Color.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

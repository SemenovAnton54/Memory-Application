//
//  EditWordRememberItem+Subviews.swift
//  Memory
//

import SwiftUI

extension EditWordRememberItemView {
    struct SelectedImage: View {
        let removeImage: () -> ()
        let imageModel: ImageViewModel

        var body: some View {
            ZStack(alignment: .topTrailing) {
                ImageView(imageViewModel: imageModel)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 150)

                Button(action: { removeImage() }) {
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

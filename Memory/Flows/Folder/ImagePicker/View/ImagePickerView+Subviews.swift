//
//  ImagePickerView+Subviews.swift
//  Memory
//
//  Created by Anton Semenov on 05.01.2025.
//

import SwiftUI

extension ImagePickerView {
    struct GridImageView: View {
        let image: ImageViewModel
        let isSelected: Bool

        var body: some View {
            ZStack {
                ImageView(imageViewModel: image)
                    .frame(height: 80)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.actionColor, lineWidth: isSelected ? 3 : 0)
                    )
                    .padding()
            }
        }
    }
}

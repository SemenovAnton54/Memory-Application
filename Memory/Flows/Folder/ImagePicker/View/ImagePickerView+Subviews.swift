//
//  SelectedImageView+Subviews.swift
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

    struct ImagesSectionView: View {
        let title: String
        let emptyListTitle: String
        let isLoading: Bool
        let imagesStates: [ImagePickerViewState.ImageViewState]
        let onImageTap: (ImageViewModel) -> Void

        var body: some View {
            VStack {
                SecondText(title)
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 0) {
                    ForEach(imagesStates) { image in
                        GridImageView(image: image.imageViewModel, isSelected: image.isSelected)
                            .onTapGesture {
                                onImageTap(image.imageViewModel)
                            }
                    }
                }

                if isLoading {
                    ProgressView()
                } else if imagesStates.isEmpty {
                    MainText(emptyListTitle)
                        .padding(.bottom, 20)
                }
            }
        }
    }

    struct ImagePickerViewButton: View {
        var body: some View {
            HStack {
                Spacer()

                Image(systemName: "plus.app")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding()
                    .foregroundStyle(Colors.actionColor)
                    .background(Colors.backgroundSecondary)
                    .cornerRadius(20)
                    .padding(20)
            }
        }
    }
}

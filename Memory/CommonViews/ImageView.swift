//
//  ImageView.swift
//  Memory
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    let imageViewModel: ImageViewModel

    init(imageViewModel: ImageViewModel) {
        self.imageViewModel = imageViewModel
    }

    var body: some View {
        ZStack {
            switch imageViewModel.imageType {
            case .remote(let url):
                KFImage.url(url)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
            case .systemName(let string):
                Image(systemName: string)
                    .resizable()
            case .local(let name):
                Image(name)
                    .resizable()
            case .data(let data):
                let image = UIImage(data: data) ?? UIImage()
                Image(uiImage: image)
                    .resizable()
            case .empty:
                EmptyView()
            }
        }
    }
}

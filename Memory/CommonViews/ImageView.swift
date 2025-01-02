//
//  ImageView.swift
//  Memory
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    let imageViewModel: ImageViewModel

    init(imageObject: ImageViewModel) {
        self.imageViewModel = imageObject
    }

    var body: some View {
        ZStack {
            switch imageViewModel.imageObject {
            case .remote(let url):
                KFImage.url(url)
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

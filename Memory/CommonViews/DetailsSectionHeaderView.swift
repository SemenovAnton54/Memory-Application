//
//  DetailsSectionHeaderView.swift
//  Memory
//

import SwiftUI

struct DetailsSectionHeaderView: View {
    let image: ImageViewModel?
    let name: String
    let icon: String
    let description: String

    var body: some View {
        if let image {
            HStack(alignment: .center) {
                ImageView(imageViewModel: image)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 150, alignment: .center)
            }
            .listRowInsets(EdgeInsets(top: -20, leading: -20, bottom: 0, trailing: -20))
        }

        VStack(alignment: .leading, spacing: 3) {
            SecondText("Name:")
            MainText(name)
        }

        VStack(spacing: 3) {
            SecondText("Icon:")
            if icon.isEmpty {
                Image(systemName: "folder")
            } else {
                MainText(icon)
            }
        }

        VStack(alignment: .leading, spacing: 3) {
            SecondText("Description:")
            MainText(description)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 3)
        }
    }
}

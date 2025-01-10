//
//  ImageViewModelTests.swift
//  Memory
//
//  Created by Anton Semenov on 10.01.2025.
//

import Testing
import Foundation

@testable import Memory

@Suite("ImageViewModel Tests")
struct ImageViewModelTests {
    @Test(
        "Initialization tests",
        arguments: [
            (1, ImageType.systemName("test")),
            (2, ImageType.empty),
            (3, ImageType.data(Data()))
        ]
    )
    func initTests(id: Int, imageType: ImageType) {
        let model = ImageModel(id: id, imageType: imageType)

        let viewModel = ImageViewModel(from: model)

        #expect(viewModel.id == model.id)
        #expect(viewModel.imageType == model.imageType)


        let viewModel2 = ImageViewModel(id: id, imageType: imageType)

        #expect(viewModel2.id == id)
        #expect(viewModel2.imageType == imageType)

        let viewModel3 = ImageViewModel(imageType: imageType)
        #expect(viewModel3.id == -1)
        #expect(viewModel3.imageType == imageType)
    }
}

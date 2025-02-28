//
//  ImagePickerRouterMock.swift
//  Memory
//
//  Created by Anton Semenov on 28.02.2025.
//

@testable import Memory

class ImagePickerRouterMock: ImagePickerRouterProtocol {
    var didClose: Bool = false

    func close() {
        didClose = true
    }
}

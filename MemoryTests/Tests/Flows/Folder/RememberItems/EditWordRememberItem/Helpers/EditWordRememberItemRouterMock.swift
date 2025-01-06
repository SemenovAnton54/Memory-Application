//
//  EditWordRememberItemRouterMock.swift
//  Memory
//

@testable import Memory

class EditWordRememberItemRouterMock: EditWordRememberItemRouterProtocol {
    var didImagePickerWithText: String?
    var didClose: Bool = false

    func close() {
        didClose = true
    }

    func imagePicker(text: String?, completion: @escaping ([Memory.ImageType]) -> Void) {
        didImagePickerWithText = text

    }
}

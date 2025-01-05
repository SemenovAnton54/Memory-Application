//
//  ImagePickerServiceProtocol.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

protocol ImagePickerServiceProtocol {
    func fetchImages(by name: String) async throws -> [ImageModel]
}

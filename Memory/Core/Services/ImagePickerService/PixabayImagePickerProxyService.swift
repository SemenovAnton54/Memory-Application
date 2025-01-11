//
//  PixabayImagePickerProxyService.swift
//  Memory
//
//  Created by Anton Semenov on 11.01.2025.
//

import Foundation

class PixabayImagePickerProxyService: ImagePickerServiceProtocol {
    enum ImagePickerError: Error {
        case invalidURL
    }

    func fetchImages(by name: String) async throws -> [ImageModel] {
        guard let url = URL(string: "http://\(APIKeys.proxyIp):8080/proxy?q=\(name.trimmingCharacters(in: .whitespacesAndNewlines))") else {
            throw ImagePickerError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let images = try JSONDecoder().decode(PixaBayResponse.self, from: data)

        return images.hits.map {
            ImageModel(id: $0.id, imageType: .remote($0.webformatURL))
        }
    }
}

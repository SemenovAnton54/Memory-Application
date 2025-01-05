//
//  PixabayImagePickerService.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import Foundation

class PixabayImagePickerService: ImagePickerServiceProtocol {
    enum ImagePickerError: Error {
        case invalidURL
    }

    private let apiKey = APIKeys.pixabay

    func fetchImages(by name: String) async throws -> [ImageModel] {
        var components = URLComponents()

        components.scheme = "https"
        components.host = "pixabay.com"
        components.path = "/api/"

        // Add query items (parameters) to the URL
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "per_page", value: "100"),
        ]

        guard let url = components.url else {
            throw ImagePickerError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)

        let images = try JSONDecoder().decode(PixaBayResponse.self, from: data)

        return images.hits.map {
            ImageModel(id: $0.id, imageType: .remote($0.webformatURL))
        }
    }
}

fileprivate struct PixaBayResponse: Decodable {
    let hits: [PixabayImage]
}

fileprivate struct PixabayImage: Decodable {
    let id: Int
    let webformatURL: URL
}

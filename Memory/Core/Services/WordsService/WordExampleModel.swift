//
//  WordExample.swift
//  Memory
//

import Foundation

struct WordExampleModel: Codable, Hashable, Identifiable {
    let id: UUID

    var example: String
    var translation: String
    var imageObject: ImageType?

    init(example: String, translation: String) {
        id = UUID()
        
        self.example = example
        self.translation = translation
    }

    init(from object: WordExampleObject) {
        id = UUID()

        example = object.example
        translation = object.translation
    }
}

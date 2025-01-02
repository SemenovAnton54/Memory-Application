//
//  WordExampleObject.swift
//  Memory
//

import Foundation
import SwiftData

@Model
final class WordExampleObject {
    var example: String
    var translation: String

    init(example: String, translation: String) {
        self.example = example
        self.translation = translation
    }

    init(model: WordExampleModel) {
        example = model.example
        translation = model.translation
    }
}


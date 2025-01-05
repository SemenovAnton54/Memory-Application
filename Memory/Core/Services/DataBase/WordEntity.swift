//
//  Item.swift
//  Memory
//

import Foundation
import SwiftData

@Model
final class WordEntity {
    @Attribute(.unique) var id: Int
    @Attribute(.spotlight) var word: String

    var transcription: String
    var translation: String
    var examples: [WordExampleModel]
    var images: [ImageType]

    init(
        id: Int,
        word: String,
        translation: String,
        transcription: String,
        images: [ImageType],
        examples: [WordExampleModel]
    ) {
        self.id = id
        self.word = word
        self.translation = translation
        self.transcription = transcription
        self.images = images
        self.examples = examples
    }

    init(model: WordModel) {
        id = model.id
        word = model.word
        translation = model.translation
        transcription = model.transcription
        images = model.images
        examples = model.examples
    }

    init(id: Int, model: NewWordModel) {
        self.id = id
        word = model.word
        translation = model.translation
        transcription = model.transcription
        images = model.images
        examples = model.examples
    }

    func update(with model: UpdateWordModel) {
        id = model.id
        word = model.word
        translation = model.translation
        transcription = model.transcription
        images = model.images
        examples = model.examples
    }
}

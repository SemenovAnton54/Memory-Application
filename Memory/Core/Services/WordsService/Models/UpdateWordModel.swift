//
//  UpdateWordModel.swift
//  Memory
//

import Foundation

struct UpdateWordModel: Equatable {
    let id: Int
    let word: String
    let translation: String
    let transcription: String
    let images: [ImageObject]
    let examples: [WordExampleModel]

    init(
        id: Int,
        word: String,
        translation: String,
        transcription: String,
        images: [ImageObject],
        examples: [WordExampleModel]
    ) {
        self.id = id
        self.word = word.trimmingCharacters(in: .whitespacesAndNewlines)
        self.translation = translation.trimmingCharacters(in: .whitespacesAndNewlines)
        self.transcription = transcription.trimmingCharacters(in: .whitespacesAndNewlines)
        self.images = images

        self.examples = examples.map {
            var example = $0

            example.example = example.example.trimmingCharacters(in: .whitespacesAndNewlines)
            example.translation = example.translation.trimmingCharacters(in: .whitespacesAndNewlines)

            return example
        }
    }
}

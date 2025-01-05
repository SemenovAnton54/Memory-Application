//
//  CreateWordModel.swift
//  Memory
//

import Foundation

struct NewWordModel: Equatable {
    let word: String
    let repeatLevel: RepeatLevel
    let translation: String
    let transcription: String
    let images: [ImageType]
    let examples: [WordExampleModel]

    init(
        word: String,
        repeatLevel: RepeatLevel,
        translation: String,
        transcription: String,
        images: [ImageType],
        examples: [WordExampleModel]
    ) {
        self.word = word.trimmingCharacters(in: .whitespacesAndNewlines)
        self.repeatLevel = repeatLevel
        self.translation = translation.trimmingCharacters(in: .whitespacesAndNewlines)
        self.transcription = transcription.trimmingCharacters(in: .whitespacesAndNewlines)
        self.images = images
        self.examples = examples
    }
}

//
//  WordModel.swift
//  Memory
//

import Foundation
import SwiftUI

struct WordModel: Equatable, Identifiable {
    let id: Int
    let word: String
    let transcription: String
    let translation: String
    let examples: [WordExampleModel]
    let images: [ImageObject]

    init(from object: WordEntity) {
        id = object.id
        word = object.word
        transcription = object.transcription
        translation = object.translation
        examples = object.examples
        images = object.images
    }

    init(id: Int, word: String, transcription: String, translation: String, examples: [WordExampleModel], images: [ImageObject]) {
        self.id = id
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.examples = examples
        self.images = images
    }
}

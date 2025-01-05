//
//  WordViewModel.swift
//  Memory
//

import Foundation
import SwiftUI

struct WordViewModel: Equatable {
    let id: Int
    let word: String
    let transcription: String
    let translation: String
    let examples: [WordExampleModel]
    let images: [ImageViewModel]

    init(from model: WordModel) {
        id = model.id
        word = model.word
        transcription = model.transcription
        translation = model.translation
        examples = model.examples
        images = model.images.enumerated().map { ImageViewModel(id: $0.offset, imageType: $0.element) }
    }

    init(id: Int, word: String, transcription: String, translation: String, examples: [WordExampleModel], images: [ImageViewModel]) {
        self.id = id
        self.word = word
        self.transcription = transcription
        self.translation = translation
        self.examples = examples
        self.images = images
    }
}

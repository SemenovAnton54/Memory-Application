//
//  EditWordRememberItemViewState.swift
//  Memory
//

import Foundation

struct EditWordRememberItemViewState {
    let isLoading: Bool
    let isNewRememberItem: Bool
    let word: String
    let translation: String
    let transcription: String
    let images: [ImageViewModel]
    let isLearning: Bool
    let examples: [WordExampleModel]
}

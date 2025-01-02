//
//  WordsServiceProtocol.swift
//  Memory
//

import Foundation

protocol WordsServiceProtocol {
    func fetchWord(id: Int) async throws -> WordModel
    func fetchWords(predicate: Predicate<WordEntity>?) async throws -> [WordModel]

    func removeWord(id: Int) async throws -> WordModel
    func updateWord(word: UpdateWordModel) async throws -> WordModel
    func createWord(word: NewWordModel) async throws -> WordModel
}

//
//  WordsService.swift
//  Memory
//

import Foundation
import SwiftData


// TODO: to think about this service
@ModelActor
actor WordsService: WordsServiceProtocol {
    enum WordsServiceError: Error {
        case wordNotExist
    }

    private var context: ModelContext { modelExecutor.modelContext }

    func fetchWord(id: Int) async throws -> WordModel {
        let object = try loadWordEntity(id: id)

        return WordModel(from: object)
    }
    
    func removeWord(id: Int) async throws -> WordModel {
        let object = try loadWordEntity(id: id)
        context.delete(object)
        
        return WordModel(from: object)
    }
    
    func updateWord(word: UpdateWordModel) async throws -> WordModel {
        let id = word.id

        let predicate = #Predicate<WordEntity> { object in
            object.id == id
        }

        var descriptor = FetchDescriptor<WordEntity>(predicate: predicate)
        descriptor.fetchLimit = 1

        guard let entity = try context.fetch(descriptor).first else {
            throw WordsServiceError.wordNotExist
        }

        entity.update(with: word)
        try context.save()

        return WordModel(from: entity)
    }
    
    func createWord(word: NewWordModel) async throws -> WordModel {
        let id = try await maxId()
        let entity = WordEntity(id: id, model: word)
        
        context.insert(entity)
        try context.save()
        
        return WordModel(from: entity)
    }

    func fetchWords(predicate: Predicate<WordEntity>?) async throws -> [WordModel] {
        let words = try context.fetch(FetchDescriptor<WordEntity>(predicate: predicate))

        return words.map(WordModel.init)
    }

    private func maxId() async throws -> Int {
        (try await fetchWords(predicate: nil).map(\.id).max() ?? 0) + 1
    }

    private func loadWordEntity(id: Int) throws -> WordEntity {
        let predicate = #Predicate<WordEntity> { object in
            object.id == id
        }

        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1

        let object = try context.fetch(descriptor)

        guard let first = object.first else {
            throw WordsServiceError.wordNotExist
        }

        return first
    }
}

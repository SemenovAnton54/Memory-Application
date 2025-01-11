//
//  LearnCardsServiceProtocol.swift
//  Memory
//

struct FetchCardFilters {
    let lastShownItemsIds: [Int]
}

struct LearnStatisticsModel {
    let learnedCount: Int
    let toLearnCount: Int
}

protocol LearnCardsServiceProtocol {
    func fetchCardItem(for folder: Int, filters: FetchCardFilters?) async throws -> RememberCardItemModel?
    func fetchStatistics(for folder: Int) async throws -> LearnStatisticsModel

    func itemCardForgotten(id: Int) async throws -> RememberCardItemModel
    func itemCardRemembered(id: Int) async throws -> RememberCardItemModel
}

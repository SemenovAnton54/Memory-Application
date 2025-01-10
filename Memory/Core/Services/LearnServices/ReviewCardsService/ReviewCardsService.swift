//
//  ReviewCardsService.swift
//  Memory
//

import Foundation

class ReviewCardsService: LearnCardsServiceProtocol {
    struct Dependencies {
        let rememberItemsService: RememberItemsServiceProtocol
        let categoriesService: CategoriesServiceProtocol
    }
    
    private let dayIntervalsForLevel: [RepeatLevel: Int] = [
        .first: 1,
        .second: 2,
        .third: 4,
        .fourth: 8,
        .fifth: 16,
        .sixth: 32,
        .seventh: 64,
    ]
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchCardItem(for folder: Int, filters: FetchCardFilters?) async throws -> RememberCardItemModel? {
        let currentDate = Date()
        let cardItemsToReview = try await fetchItems(for: folder).filter { isCardItemToReview(item: $0, to: currentDate) }
        let notShownCardItems = cardItemsToReview.filter { filters?.lastShownItemsIds.contains($0.id) == false }

        guard let firstItem = notShownCardItems.first else {
            return cardItemsToReview.randomElement()
        }
        
        return firstItem
    }
    
    func fetchStatistics(for folder: Int) async throws -> LearnStatisticsModel {
        let currentDate = Date()
        let cardItemsToReview = try await fetchItems(for: folder).filter { isCardItemToReview(item: $0, to: currentDate) }
        let learnedTodayItems = cardItemsToReview.filter { $0.lastIncreasedLevelAt?.isInSameDay(as: currentDate) == true } // bug to fix logic now only item to learn show this

        return LearnStatisticsModel(
            learnedCount: learnedTodayItems.count,
            toLearnCount: cardItemsToReview.count
        )
    }
    
    func itemCardForgotten(id: Int) async throws -> RememberCardItemModel {
        let item = try await dependencies.rememberItemsService.fetchItem(id: id)
        let previousLevel = item.repeatLevel.previous()

        guard previousLevel > .first else {
            return item
        }

        return try await dependencies.rememberItemsService.decreaseRepeatLevel(id: id)
    }
    
    func itemCardRemembered(id: Int) async throws -> RememberCardItemModel {
        try await dependencies.rememberItemsService.increaseRepeatLevel(id: id)
    }
    
    func isCardItemToReview(item: RememberCardItemModel, to date: Date = Date()) -> Bool {
        guard let day = dayIntervalsForLevel[item.repeatLevel],
              let lastIncreasedLevelAt = item.lastIncreasedLevelAt else {
            return false
        }

        let showOnDate = lastIncreasedLevelAt.addingTimeInterval(60 * 60 * 24 * Double(day))

        return showOnDate < date
    }

    private func fetchItems(for folder: Int) async throws -> [RememberCardItemModel] {
        let categories = try await dependencies.categoriesService.fetchCategories(for: folder)
        let rememberItems = try await dependencies.rememberItemsService.fetchItems(for: categories.map(\.id))

        return rememberItems
    }
}

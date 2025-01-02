//
//  LearnNewCardsService.swift
//  Memory
//

import Foundation

class LearnNewItemsService: LearnCardsServiceProtocol {
    struct Dependencies {
        let rememberItemsService: RememberItemsServiceProtocol
        let categoriesService: CategoriesServiceProtocol
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func fetchCardItem(for folder: Int, filters: FetchCardFilters?) async throws -> RememberCardItemModel? {
        let newItems = try await fetchItems(for: folder).filter { $0.repeatLevel == .newItem || $0.repeatLevel == .learning }
        let itemsNotShown = newItems.filter { filters?.lastShownItemsIds.contains($0.id) == false }

        guard let firstItem = itemsNotShown.first else {
            return newItems.randomElement()
        }

        return firstItem
    }
    
    func fetchStatistics(for folder: Int) async throws -> LearnStatisticsModel {
        let today = Date()
        let items = try await fetchItems(for: folder)
        let newItems = items.filter { $0.repeatLevel == .newItem || $0.repeatLevel == .learning }
        let learnedTodayItems = items.filter { $0.lastIncreasedLevelAt?.isInSameDay(as: today) == true }

        return LearnStatisticsModel(
            learnedCount: learnedTodayItems.count,
            toLearnCount: newItems.count
        )
    }

    func itemCardForgotten(id: Int) async throws -> RememberCardItemModel {
        try await dependencies.rememberItemsService.decreaseRepeatLevel(id: id)
    }

    func itemCardRemembered(id: Int) async throws -> RememberCardItemModel {
        try await dependencies.rememberItemsService.increaseRepeatLevel(id: id)
    }

    private func fetchItems(for folder: Int) async throws -> [RememberCardItemModel] {
        let categories = try await dependencies.categoriesService.fetchCategories(for: folder)
        let rememberItems = try await dependencies.rememberItemsService.fetchItems(for: categories.map(\.id))

        return rememberItems
    }
}

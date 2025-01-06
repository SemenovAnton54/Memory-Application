//
//  CategoryDetailsReducerTests.swift
//  Memory
//
//  Created by Anton Semenov on 06.01.2025.
//

import Testing

@testable import Memory

@Suite
final class CategoryDetailsReducerTests {
    private static var categoryId = 1

    let reducer = CategoryDetailsReducer()

    var state = CategoryDetailsState(id: CategoryDetailsReducerTests.categoryId)

    var router = CategoryDetailsRouterMock()

    @Test("Test deleteCategory event")
    func testSendEventDeleteCategoryOutputStateDeleteCategoryRequestChanged() {
        #expect(state.deleteCategoryRequest == nil)

        reducer.reduce(state: &state, event: .deleteCategory)
        #expect(state.deleteCategoryRequest?.payload.id == state.id)
    }

    @Test("Test categoryDeleted event result success")
    func testSendEventCategoryDeletedOutputStateDeleteCategoryRequestChanged() {
        state.deleteCategoryRequest = FeedbackRequest(.init(id: Self.categoryId))
        let category = MockCategoryModel.mockCategory()

        reducer.reduce(state: &state, event: .categoryDeleted(.success(category)))

        #expect(state.deleteCategoryRequest == nil)
        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didClose == true)
    }

    @Test("Test categoryDeleted event result failure")
    func testSendEventCategoryDeletedOutputStateDeleteCategoryRequestNotChanged() {
        state.deleteCategoryRequest = FeedbackRequest(.init(id: Self.categoryId))

        reducer.reduce(state: &state, event: .categoryDeleted(.failure(MockError.mockError)))

        #expect(state.deleteCategoryRequest == nil)
    }

    @Test("Test categoryFetched event result success")
    func testSendEventCategoryFetchedOutputStateFetchCategoryRequestAndCategoryChanged() {
        state.fetchCategoryRequest = FeedbackRequest(.init(id: Self.categoryId))
        let category = MockCategoryModel.mockCategory()

        reducer.reduce(state: &state, event: .categoryFetched(.success(category)))

        #expect(state.fetchCategoryRequest == nil)
        #expect(state.category?.id == category.id)
    }

    @Test("Test categoryFetched event result failure")
    func testSendEventCategoryFetchedOutputStateFetchCategoryRequestAndCategoryNotChanged() {
        state.fetchCategoryRequest = FeedbackRequest(.init(id: Self.categoryId))

        reducer.reduce(state: &state, event: .categoryFetched(.failure(MockError.mockError)))

        #expect(state.fetchCategoryRequest == nil)
    }

    @Test("Test rememberItemsFetched event result success")
    func testSendEventRememberItemsFetchedOutputStateFetchRememberItemsRequestAndRememberItemsChanged() {
        state.fetchRememberItemsRequest = FeedbackRequest(.init(categoryId: Self.categoryId))
        let items = [MockRememberItemModel.mockRememberItemModel(id: 1), MockRememberItemModel.mockRememberItemModel(id: 3)]

        reducer.reduce(state: &state, event: .rememberItemsFetched(.success(items)))

        #expect(state.fetchRememberItemsRequest == nil)
        #expect(state.rememberItems.count == items.count)
    }

    @Test("Test rememberItemsFetched event result failure")
    func testSendEventRememberItemsFetchedOutputStateFetchRememberItemsRequestAndRememberItemsNotChanged() {
        state.fetchRememberItemsRequest = FeedbackRequest(.init(categoryId: Self.categoryId))

        reducer.reduce(state: &state, event: .rememberItemsFetched(.failure(MockError.mockError)))

        #expect(state.fetchRememberItemsRequest == nil)
        #expect(state.rememberItems.isEmpty)
    }

    @Test("Test deleteRememberItem event result success")
    func testSendEventDeleteRememberItemOutputStateDeleteRememberItemRequestChanged() {
        let id = 2

        reducer.reduce(state: &state, event: .deleteRememberItem(id: id))

        #expect(state.deleteRememberItemRequest?.payload.id == id)
    }

    @Test("Test rememberItemDeleted event result success")
    func testSendEventRememberItemDeletedOutputStateDeleteRememberItemRequestAndRememberItemsChanged() {
        let item = MockRememberItemModel.mockRememberItemModel(id: 1)
        let items = [item, MockRememberItemModel.mockRememberItemModel(id: 3)]

        state.rememberItems = items
        state.deleteRememberItemRequest = FeedbackRequest(.init(id: item.id))
        #expect(state.rememberItems.first(where: { $0.id == item.id }) != nil)

        reducer.reduce(state: &state, event: .rememberItemDeleted(.success(item)))

        #expect(state.deleteRememberItemRequest == nil)
        #expect(state.rememberItems.first(where: { $0.id == item.id }) == nil)
        #expect(state.rememberItems.count == (items.count - 1))
    }

    @Test("Test rememberItemDeleted event result failure")
    func testSendEventRememberItemDeletedOutputStateDeleteRememberItemRequestAndRememberItemsNotChanged() {
        let item = MockRememberItemModel.mockRememberItemModel(id: 1)
        let items = [item, MockRememberItemModel.mockRememberItemModel(id: 3)]

        state.rememberItems = items
        state.deleteRememberItemRequest = FeedbackRequest(.init(id: item.id))
        #expect(state.rememberItems.first(where: { $0.id == item.id }) != nil)

        reducer.reduce(state: &state, event: .rememberItemDeleted(.failure(MockError.mockError)))

        #expect(state.deleteRememberItemRequest == nil)
        #expect(state.rememberItems.first(where: { $0.id == item.id }) != nil)
    }

    @Test("Test addRememberItem event")
    func testSendEventAddRememberItemOutputStateRouterRequestChanged() {
        reducer.reduce(state: &state, event: .addRememberItem)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didNewRememberItemWithCategoryId == Self.categoryId)
    }

    @Test("Test editCategory event")
    func testSendEventEditCategoryOutputStateRouterRequestChanged() {
        reducer.reduce(state: &state, event: .editCategory)

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didEditCategoryWithId == Self.categoryId)
    }

    @Test("Test categoryChanged event")
    func testSendCategoryChangedCategoryOutputStateFetchRememberItemsRequestAndFetchCategoryRequestChanged() {
        reducer.reduce(state: &state, event: .categoryChanged)

        #expect(state.fetchCategoryRequest?.payload.id == Self.categoryId)
        #expect(state.fetchRememberItemsRequest?.payload.categoryId == Self.categoryId)
    }

    @Test("Test categoryDetails event")
    func testSendCategoryDetailsCategoryOutputStateRouterRequestChanged() {
        let rememberItemId = 2
        reducer.reduce(state: &state, event: .editRememberItem(id: rememberItemId))

        #expect(state.routingRequest != nil)

        performRouterRequest(from: state, to: router)

        #expect(router.didEditRememberItemWithId == rememberItemId)
    }
}

//
//  CategoryDetailsPresenter.swift
//  Memory
//

struct CategoryDetailsPresenter {
    func present(state: CategoryDetailsState) -> CategoryDetailsViewState {
        CategoryDetailsViewState(
            category: category(state: state),
            rememberItems: rememberItems(state: state)
        )
    }
}

extension CategoryDetailsPresenter {
    func category(state: CategoryDetailsState) -> CategoryViewModel? {
        guard let category = state.category else {
            return nil
        }

        return CategoryViewModel(from: category)
    }

    func rememberItems(state: CategoryDetailsState) -> [RememberCardItemViewModel] {
        state.rememberItems.map(RememberCardItemViewModel.init(from:))
    }
}

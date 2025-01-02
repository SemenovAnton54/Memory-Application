//
//  EditCategoryPresenter.swift
//  Memory
//

struct EditCategoryPresenter {
    func present(state: EditCategoryState) -> EditCategoryViewState {
        EditCategoryViewState(
            isNewCategory: state.id == nil,
            title: state.name,
            description: state.description,
            icon: state.icon,
            image: state.image.flatMap { ImageViewModel(id: 1, imageObject: $0) }
        )
    }
}

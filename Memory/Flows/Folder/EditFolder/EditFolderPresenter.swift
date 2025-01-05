//
//  EditFolderPresenter.swift
//  Memory
//

struct EditFolderPresenter {
    func present(_ state: EditFolderState) -> EditFolderViewState {
        EditFolderViewState(
            isNewFolder: state.id == nil,
            title: state.name,
            description: state.description,
            icon: state.icon,
            isFavorite: state.isFavorite,
            image: state.image.flatMap(ImageViewModel.init(imageType:))
        )
    }
}

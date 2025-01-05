//
//  FoldersCoordinatorState+Routers.swift
//  Memory
//

extension RememberItemCoordinatorState {
    struct FolderDetailsRouter: EditWordRememberItemRouterProtocol {
        let state: RememberItemCoordinatorState

        func close() {
            state.onClose()
        }

        func imagePicker(text: String?, completion: @escaping ([ImageType]) -> ()) {
            state.presentedItem = .imagePicker(text, completion: HashableWrapper(completion))
        }
    }

    struct ImagePickerRouter: ImagePickerRouterProtocol {
        let state: RememberItemCoordinatorState

        func close() {
            state.presentedItem = nil
        }
    }
}

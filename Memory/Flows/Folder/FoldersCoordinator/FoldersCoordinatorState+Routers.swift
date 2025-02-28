//
//  FoldersCoordinatorState+Routers.swift
//  Memory
//

extension FoldersCoordinatorState {
    struct FolderDetailsRouter: FolderDetailsRouterProtocol {
        let state: FoldersCoordinatorState

        func close() {
            state.onClose?()
        }
        
        func editFolder(id: Int) {
            state.presentedItem = .editFolder(id: id)
        }

        func newCategory(for folder: Int) {
            state.presentedItem = .editCategory(id: nil, folderId: folder)
        }
        
        func categoryDetails(id: Int) {
            state.nextItem = .categoryDetails(id: id)
        }
    }

    struct CategoryDetailsRouter: CategoryDetailsRouterProtocol {
        let state: FoldersCoordinatorState

        func close() {
            state.onClose?()
        }
        
        func editCategory(id: Int) {
            state.presentedItem = .editCategory(id: id, folderId: nil)
        }
        
        func newRememberItem(for category: Int) {
            state.presentedItem = .editWordRememberItem(id: nil, categoriesIds: [category])
        }
        
        func editRememberItem(id: Int) {
            state.presentedItem = .editWordRememberItem(id: id, categoriesIds: nil)
        }
    }
}

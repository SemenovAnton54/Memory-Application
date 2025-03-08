//
//  FoldersComponent.swift
//  Memory
//
//  Created by Anton Semenov on 28.02.2025.
//

import NeedleFoundation

protocol FoldersDependencies: Dependency {
    var appEventsClient: AppEventsClientProtocol { get }
    var foldersService: FoldersServiceProtocol { get }
    var rememberItemsService: RememberItemsServiceProtocol { get }
    var categoriesService: CategoriesServiceProtocol { get }
}

class FoldersComponent: Component<FoldersDependencies>, FoldersCoordinatorFactoryProtocol {
    func makeState(for route: FoldersRoute, onClose: (() -> ())?) -> FoldersCoordinatorState {
        FoldersCoordinatorState(
            dependencies: FoldersCoordinatorState.Dependencies(
                foldersCoordinatorFactory: self,
                rememberItemCoordinatorFactory: rememberItemsComponent,
                foldersListScreenFactory: foldersListScreenFactory(),
                editFolderFactory: editFolderFactory(),
                editCategoryFactory: editCategoryFactory(),
                folderDetailsFactory: folderDetailsFactory(),
                categoryDetailsFactory: categoryDetailsFactory()
            ),
            route: route,
            onClose: onClose
        )
    }

    var rememberItemsComponent: RememberItemsComponent {
        RememberItemsComponent(parent: self)
    }

    private func foldersListScreenFactory() -> FoldersListScreenFactory {
        FoldersListScreenFactory(
            dependencies: FoldersListScreenFactory.Dependencies(
                foldersService: dependency.foldersService,
                appEventsClient: dependency.appEventsClient
            )
        )
    }

    private func editFolderFactory() -> EditFolderFactory {
        EditFolderFactory(
            dependencies: EditFolderFactory.Dependencies(
                foldersService: dependency.foldersService
            )
        )
    }

    private func editCategoryFactory() -> EditCategoryFactory {
        EditCategoryFactory(
            dependencies: EditCategoryFactory.Dependencies(
                categoriesService: dependency.categoriesService
            )
        )
    }

    private func folderDetailsFactory() -> FolderDetailsFactory {
        FolderDetailsFactory(
            dependencies: FolderDetailsFactory.Dependencies(
                foldersService: dependency.foldersService,
                categoriesService: dependency.categoriesService,
                appEventsClient: dependency.appEventsClient
            )
        )
    }

    private func categoryDetailsFactory() -> CategoryDetailsFactory {
        CategoryDetailsFactory(
            dependencies: CategoryDetailsFactory.Dependencies(
                categoriesService: dependency.categoriesService,
                rememberItemsService: dependency.rememberItemsService,
                appEventsClient: dependency.appEventsClient
            )
        )
    }
}

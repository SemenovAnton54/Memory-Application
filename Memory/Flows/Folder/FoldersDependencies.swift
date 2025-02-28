//
//  FoldersDependencies.swift
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
        foldersCoordinatorFactory.makeState(
            dependencies: FoldersCoordinatorState.Dependencies(
                appEventsClient: dependency.appEventsClient,
                foldersService: dependency.foldersService,
                categoriesService: dependency.categoriesService,
                rememberItemsService: dependency.rememberItemsService,
                foldersCoordinatorFactory: self
            ),
            for: route,
            onClose: onClose
        )
    }

    func makeView(for state: FoldersCoordinatorState) -> FoldersCoordinatorView {
        FoldersCoordinatorView(state: state)
    }

    var foldersCoordinatorFactory: FoldersCoordinatorFactory {
        FoldersCoordinatorFactory()
    }
}

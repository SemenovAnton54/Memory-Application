//
//  RemeberItemsDependencies.swift
//  Memory
//
//  Created by Anton Semenov on 28.02.2025.
//

import NeedleFoundation

protocol RemeberItemsDependencies: Dependency {
    var rememberItemsService: RememberItemsServiceProtocol { get }
    var imagePickerService: ImagePickerServiceProtocol { get }
}

class RememberItemsComponent: Component<RemeberItemsDependencies>, RememberItemCoordinatorFactoryProtocol {
    func makeState(route: RememberItemRouter, onClose: @escaping () -> ()) -> RememberItemCoordinatorState {
        RememberItemCoordinatorState(
            dependencies: RememberItemCoordinatorState.Dependencies(
                rememberItemCoordinatorFactory: self,
                editWordRememberItemFactory: editWordRememberItemFactory(),
                imagePickerFactory: imagePickerFactory()
            ),
            route: route,
            onClose: onClose
        )
    }

    private func editWordRememberItemFactory() -> EditWordRememberItemFactory {
        EditWordRememberItemFactory(
            dependencies: EditWordRememberItemFactory.Dependencies(
                rememberItemsService: dependency.rememberItemsService
            )
        )
    }

    private func imagePickerFactory() -> ImagePickerFactory {
        ImagePickerFactory(
            dependencies: ImagePickerFactory.Dependencies(
                imagePickerService: dependency.imagePickerService
            )
        )
    }
}

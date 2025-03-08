//
//  RootComponent.swift
//  Memory
//
//  Created by Anton Semenov on 28.02.2025.
//

import SwiftData
import NeedleFoundation

class RootComponent: BootstrapComponent {
    public var sharedModelContainer: ModelContainer {
        shared {
            let schema = Schema([
                WordEntity.self,
                FolderEntity.self,
                CategoryEntity.self,
                RememberCardItemEntity.self,
            ])
            
            let isUITests = CommandLine.arguments.contains("UITests")
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isUITests)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }

    public var appEventsClient: AppEventsClientProtocol {
        appEventFactory.makeClient()
    }

    public var imagePickerService: ImagePickerServiceProtocol {
//        PixabayImagePickerService() sanctions, I hope you understand
        shared {
            PixabayImagePickerProxyService()
        }
    }

    public var foldersService: FoldersServiceProtocol {
        shared {
            FoldersServiceDecorator(
                dependencies: FoldersServiceDecorator.Dependencies(
                    foldersService: FoldersService(modelContainer: sharedModelContainer),
                    appEventsClient: appEventsClient
                )
            )
        }
    }

    public var categoriesService: CategoriesServiceProtocol {
        shared {
            CategoriesServiceDecorator(
                dependencies: CategoriesServiceDecorator.Dependencies(
                    categoriesService: CategoriesService(modelContainer: sharedModelContainer),
                    appEventsClientProtocol: appEventsClient
                )
            )
        }
    }

    public var rememberItemsService: RememberItemsServiceProtocol {
        shared {
            RememberItemsServiceDecorator(
                dependencies: RememberItemsServiceDecorator.Dependencies(
                    rememberItemsService: RememberItemsService(modelContainer: sharedModelContainer),
                    appEventsClientProtocol: appEventsClient
                )
            )
        }
    }

    public var learnNewItemsService: LearnCardsServiceProtocol {
        shared {
            LearnNewItemsService(
                dependencies: LearnNewItemsService.Dependencies(
                    rememberItemsService: rememberItemsService,
                    categoriesService: categoriesService
                )
            )
        }
    }

    public var reviewItemsService: LearnCardsServiceProtocol {
        shared {
            ReviewCardsService(
                dependencies: ReviewCardsService.Dependencies(
                    rememberItemsService: rememberItemsService,
                    categoriesService: categoriesService
                )
            )
        }
    }

    var rootState: CoordinatorRootState {
        CoordinatorRootState(
            dependencies: CoordinatorRootState.Dependencies(
                foldersCoordinatorFactory: foldersComponent,
                learnCoordinatorFactory: learnComponent
            )
        )
    }

    var foldersComponent: FoldersComponent {
        FoldersComponent(parent: self)
    }

    var learnComponent: LearnComponent {
        LearnComponent(parent: self)
    }

    private var appEventFactory = AppEventFactory()
}

//
//  LearnComponent.swift
//  Memory
//
//  Created by Anton Semenov on 28.02.2025.
//

import NeedleFoundation

protocol LearnDependencies: Dependency {
    var appEventsClient: AppEventsClientProtocol { get }
    var foldersService: FoldersServiceProtocol { get }
    var rememberItemsService: RememberItemsServiceProtocol { get }
    var categoriesService: CategoriesServiceProtocol { get }
}

class LearnComponent: Component<LearnDependencies>, LearnCoordinatorFactoryProtocol {
    public var speechUtteranceService: SpeechUtteranceServiceProtocol {
        shared {
            SpeechUtteranceService()
        }
    }
    
    public var learnNewItemsService: LearnCardsServiceProtocol {
        shared {
            LearnNewItemsService(
                dependencies: LearnNewItemsService.Dependencies(
                    rememberItemsService: dependency.rememberItemsService,
                    categoriesService: dependency.categoriesService
                )
            )
        }
    }

    public var reviewItemsService: LearnCardsServiceProtocol {
        shared {
            ReviewCardsService(
                dependencies: ReviewCardsService.Dependencies(
                    rememberItemsService: dependency.rememberItemsService,
                    categoriesService: dependency.categoriesService
                )
            )
        }
    }

    func makeState(for route: LearnRoute, onClose: (() -> ())?) -> LearnCoordinatorState {
        LearnCoordinatorState(
            dependencies: LearnCoordinatorState.Dependencies(
                learnCoordinatorFactory: self,
                rememberItemCoordinatorFactory: rememberItemsComponent,
                learnMainFactory: learnMainFactory(),
                selectFolderLearningModeFactory: selectFolderLearningModeFactory(),
                learnFoldersListFactory: learnFoldersListFactory(),
                learnCardFactory: learnCardFactory()
            ),
            route: route,
            onClose: onClose
        )
    }

    var rememberItemsComponent: RememberItemsComponent {
        RememberItemsComponent(parent: self)
    }

    private func learnMainFactory() -> LearnMainFactory {
        LearnMainFactory(
            dependencies: LearnMainFactory.Dependencies(
                foldersService: dependency.foldersService,
                appEventsClient: dependency.appEventsClient,
                learnNewItemsService: learnNewItemsService,
                reviewItemsService: reviewItemsService
            )
        )
    }

    private func selectFolderLearningModeFactory() -> SelectFolderLearningModeFactory {
        SelectFolderLearningModeFactory(
            dependencies: SelectFolderLearningModeFactory.Dependencies(
                learnNewItemsService: learnNewItemsService,
                reviewItemsService: reviewItemsService
            )
        )
    }

    private func learnFoldersListFactory() -> LearnFoldersListFactory {
        LearnFoldersListFactory(
            dependencies: LearnFoldersListFactory.Dependencies(
                foldersService: dependency.foldersService
            )
        )
    }

    private func learnCardFactory() -> LearnCardFactory {
        LearnCardFactory(
            dependencies: LearnCardFactory.Dependencies(
                speechUtteranceService: speechUtteranceService,
                appEventsClient: dependency.appEventsClient,
                rememberItemsService: dependency.rememberItemsService,
                learnNewItemsService: learnNewItemsService,
                reviewItemsService: reviewItemsService
            )
        )
    }
}

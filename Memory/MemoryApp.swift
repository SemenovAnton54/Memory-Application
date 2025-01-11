//
//  MemoryApp.swift
//  Memory
//

import SwiftUI
import SwiftData

@main
struct MemoryApp: App {
    static var appEventFactory: AppEventFactory = AppEventFactory()

//    static var wordsService: WordsServiceProtocol {
//        WordsService(modelContainer: sharedModelContainer)
//    }

    static var speechUtteranceService: SpeechUtteranceServiceProtocol {
        SpeechUtteranceService()
    }

    static var imagePickerService: ImagePickerServiceProtocol {
//        PixabayImagePickerService() sanctions, I hope you understand
        PixabayImagePickerProxyService()
    }

    static var foldersService: FoldersServiceProtocol {
        FoldersServiceDecorator(
            dependencies: FoldersServiceDecorator.Dependencies(
                foldersService: FoldersService(modelContainer: sharedModelContainer),
                appEventsClient: Self.appEventsClient()
            )
        )
    }

    static var categoriesService: CategoriesServiceProtocol {
        CategoriesServiceDecorator(
            dependencies: CategoriesServiceDecorator.Dependencies(
                categoriesService: CategoriesService(modelContainer: sharedModelContainer),
                appEventsClientProtocol: Self.appEventsClient()
            )
        )
    }

    static var rememberItemsService: RememberItemsServiceProtocol {
        RememberItemsServiceDecorator(
            dependencies: RememberItemsServiceDecorator.Dependencies(
                rememberItemsService: RememberItemsService(modelContainer: sharedModelContainer),
                appEventsClientProtocol: Self.appEventsClient()
            )
        )
    }

    static func appEventsClient() -> AppEventsClientProtocol {
        appEventFactory.makeClient()
    }

    static var learnNewItemsService: LearnCardsServiceProtocol {
        LearnNewItemsService(
            dependencies: LearnNewItemsService.Dependencies(
                rememberItemsService: Self.rememberItemsService,
                categoriesService: Self.categoriesService
            )
        )
    }

    static var reviewItemsService: LearnCardsServiceProtocol {
        ReviewCardsService(
            dependencies: ReviewCardsService.Dependencies(
                rememberItemsService: Self.rememberItemsService,
                categoriesService: Self.categoriesService
            )
        )
    }

    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WordEntity.self,
            FolderEntity.self,
            CategoryEntity.self,
            RememberCardItemEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private let state = CoordinatorRootState()

    init() {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = standardAppearance
        UITabBar.appearance().backgroundColor = UIColor(Colors.background)
    }

    var body: some Scene {
        WindowGroup {
            CoordinatorRootView(state: state)
        }
    }
}

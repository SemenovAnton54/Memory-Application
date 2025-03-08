

import NeedleFoundation
import SwiftData
import SwiftUI

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

private func parent2(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class LearnDependenciesbfb5f715654eebb368a7Provider: LearnDependencies {
    var appEventsClient: AppEventsClientProtocol {
        return rootComponent.appEventsClient
    }
    var foldersService: FoldersServiceProtocol {
        return rootComponent.foldersService
    }
    var rememberItemsService: RememberItemsServiceProtocol {
        return rootComponent.rememberItemsService
    }
    var categoriesService: CategoriesServiceProtocol {
        return rootComponent.categoriesService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->LearnComponent
private func factoryda029a01ae983fc3694eb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return LearnDependenciesbfb5f715654eebb368a7Provider(rootComponent: parent1(component) as! RootComponent)
}
private class FoldersDependenciesc304d5b2a26a8ab1757bProvider: FoldersDependencies {
    var appEventsClient: AppEventsClientProtocol {
        return rootComponent.appEventsClient
    }
    var foldersService: FoldersServiceProtocol {
        return rootComponent.foldersService
    }
    var rememberItemsService: RememberItemsServiceProtocol {
        return rootComponent.rememberItemsService
    }
    var categoriesService: CategoriesServiceProtocol {
        return rootComponent.categoriesService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->FoldersComponent
private func factorye13ab019667ac858910bb3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return FoldersDependenciesc304d5b2a26a8ab1757bProvider(rootComponent: parent1(component) as! RootComponent)
}
private class RemeberItemsDependencies7d8a71fa4925cd20a618Provider: RemeberItemsDependencies {
    var rememberItemsService: RememberItemsServiceProtocol {
        return rootComponent.rememberItemsService
    }
    var imagePickerService: ImagePickerServiceProtocol {
        return rootComponent.imagePickerService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->LearnComponent->RememberItemsComponent
private func factorye93d0be1b3b13686ada6a9403e3301bb54f80df0(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RemeberItemsDependencies7d8a71fa4925cd20a618Provider(rootComponent: parent2(component) as! RootComponent)
}

#else
extension RootComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["sharedModelContainer-ModelContainer"] = { [unowned self] in self.sharedModelContainer as Any }
        localTable["appEventsClient-AppEventsClientProtocol"] = { [unowned self] in self.appEventsClient as Any }
        localTable["imagePickerService-ImagePickerServiceProtocol"] = { [unowned self] in self.imagePickerService as Any }
        localTable["foldersService-FoldersServiceProtocol"] = { [unowned self] in self.foldersService as Any }
        localTable["categoriesService-CategoriesServiceProtocol"] = { [unowned self] in self.categoriesService as Any }
        localTable["rememberItemsService-RememberItemsServiceProtocol"] = { [unowned self] in self.rememberItemsService as Any }
        localTable["learnNewItemsService-LearnCardsServiceProtocol"] = { [unowned self] in self.learnNewItemsService as Any }
        localTable["reviewItemsService-LearnCardsServiceProtocol"] = { [unowned self] in self.reviewItemsService as Any }
    }
}
extension LearnComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\LearnDependencies.appEventsClient] = "appEventsClient-AppEventsClientProtocol"
        keyPathToName[\LearnDependencies.foldersService] = "foldersService-FoldersServiceProtocol"
        keyPathToName[\LearnDependencies.rememberItemsService] = "rememberItemsService-RememberItemsServiceProtocol"
        keyPathToName[\LearnDependencies.categoriesService] = "categoriesService-CategoriesServiceProtocol"
        localTable["speechUtteranceService-SpeechUtteranceServiceProtocol"] = { [unowned self] in self.speechUtteranceService as Any }
        localTable["learnNewItemsService-LearnCardsServiceProtocol"] = { [unowned self] in self.learnNewItemsService as Any }
        localTable["reviewItemsService-LearnCardsServiceProtocol"] = { [unowned self] in self.reviewItemsService as Any }
    }
}
extension FoldersComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\FoldersDependencies.appEventsClient] = "appEventsClient-AppEventsClientProtocol"
        keyPathToName[\FoldersDependencies.foldersService] = "foldersService-FoldersServiceProtocol"
        keyPathToName[\FoldersDependencies.rememberItemsService] = "rememberItemsService-RememberItemsServiceProtocol"
        keyPathToName[\FoldersDependencies.categoriesService] = "categoriesService-CategoriesServiceProtocol"

    }
}
extension RememberItemsComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\RemeberItemsDependencies.rememberItemsService] = "rememberItemsService-RememberItemsServiceProtocol"
        keyPathToName[\RemeberItemsDependencies.imagePickerService] = "imagePickerService-ImagePickerServiceProtocol"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->LearnComponent", factoryda029a01ae983fc3694eb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->FoldersComponent", factorye13ab019667ac858910bb3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->LearnComponent->RememberItemsComponent", factorye93d0be1b3b13686ada6a9403e3301bb54f80df0)
    registerProviderFactory("^->RootComponent->FoldersComponent->RememberItemsComponent", factorye93d0be1b3b13686ada6a9403e3301bb54f80df0)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}

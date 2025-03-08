//
//  MemoryApp.swift
//  Memory
//

import SwiftUI
import SwiftData
import NeedleFoundation

@main
struct MemoryApp: App {
    private let state: CoordinatorRootState
    private let rootComponent: RootComponent

    init() {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = standardAppearance
        UITabBar.appearance().backgroundColor = UIColor(Colors.background)

        registerProviderFactories()

        let rootComponent = RootComponent()
        self.rootComponent = rootComponent
        self.state = rootComponent.rootState
    }

    var body: some Scene {
        WindowGroup {
            CoordinatorRootView(
                state: state
            )
        }
    }
}

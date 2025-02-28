//
//  CoordinatorRootView.swift
//  Memory
//

import SwiftUI

struct CoordinatorRootView: View {
    let foldersCoordinatorFactory: any FoldersCoordinatorFactoryProtocol

    @ObservedObject var state: CoordinatorRootState

    var body: some View {
        NavigationStack(path: $state.path) {
            linkDestination(link: .tabBar)
                .navigationDestination(for: RootRouter.self, destination: {
                    linkDestination(link: $0)
                })
                .sheet(item: $state.presentedItem, content: sheetContent)
        }
    }

    @ViewBuilder func sheetContent(item: RootRouter) -> some View {
        switch item {
        case .tabBar:
            EmptyView()
        }
    }

    @ViewBuilder func linkDestination(link: RootRouter) -> some View {
        switch link {
        case .tabBar:
            AppTabBarView(
                tabs: AppTabBarTabs(
                    tabs: [
                        AppTabBarTabs.Tab(
                            id: .learn,
                            view: AnyView(
                                LearnCoordinatorFactory().makeView(for: state.learnCoordinatorState())
                            )
                        ),
                        AppTabBarTabs.Tab(
                            id: .list,
                            view: AnyView(
                                foldersCoordinatorFactory.makeView(for: state.foldersCoordinatorState())
                            )
                        ),
                    ]
                )
            )
        }
    }
}

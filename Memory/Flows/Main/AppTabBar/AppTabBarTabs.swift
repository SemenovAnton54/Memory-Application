//
//  AppTabBarTabs.swift
//  Memory
//

import SwiftUI

class AppTabBarTabs: ObservableObject {
    enum TabIdentifier: Hashable {
        case learn
        case list
    }

    struct Tab: Identifiable {
        let id: TabIdentifier
        let view: AnyView

        var title: String {
            switch id {
            case .learn:
                return "Learn"
            case .list:
                return "List"
            }
        }

        var icon: String {
            switch id {
            case .learn:
                return "menucard"
            case .list:
                return "list.bullet"
            }
        }
    }

    @Published var tabs: [Tab]

    init(tabs: [Tab]) {
        self.tabs = tabs
    }
}

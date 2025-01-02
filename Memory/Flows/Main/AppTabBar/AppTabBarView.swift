//
//  AppTabBarView.swift
//  Memory
//

import SwiftUI
import SwiftData

struct AppTabBarView: View {
    @ObservedObject var tabs: AppTabBarTabs

    init(tabs: AppTabBarTabs) {
        self.tabs = tabs
    }

    var body: some View {
        TabView() {
            ForEach(tabs.tabs, id:\.id) { tab in
                tab
                    .view
                    .tabItem {
                        TabItem(image: tab.icon, text: tab.title)
                    }
            }
        }
        .tint(Colors.actionColor)
    }
}

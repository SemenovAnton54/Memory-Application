//
//  RootRouter.swift
//  Memory
//

import Foundation
import SwiftUI

enum RootRouter: Hashable, Identifiable {
    case tabBar

    var id: String {
        switch self {
        case .tabBar:
            return "tabBar"
        }
    }
}

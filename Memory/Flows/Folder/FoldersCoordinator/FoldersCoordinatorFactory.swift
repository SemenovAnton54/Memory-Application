//
//  FoldersCoordinatorFactory.swift
//  Memory
//

import SwiftUI

protocol FoldersCoordinatorFactoryProtocol {
    associatedtype FoldersView: View

    func makeState(
        for route: FoldersRoute,
        onClose: (() -> ())?
    ) -> FoldersCoordinatorState

    func makeView(for state: FoldersCoordinatorState) -> FoldersView
}

struct FoldersCoordinatorFactory {
    func makeState(
        dependencies: FoldersCoordinatorState.Dependencies,
        for route: FoldersRoute,
        onClose: (() -> ())? = nil
    ) -> FoldersCoordinatorState {
        FoldersCoordinatorState(dependencies: dependencies, route: route, onClose: onClose)
    }

    func makeView(for state: FoldersCoordinatorState) -> some View {
        FoldersCoordinatorView(state: state)
    }
}

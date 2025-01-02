//
//  FoldersCoordinatorFactory.swift
//  Memory
//

import SwiftUI

struct FoldersCoordinatorFactory {
    func makeState(route: FoldersRoute, onClose: @escaping () -> ()) -> FoldersCoordinatorState {
        FoldersCoordinatorState(route: route, onClose: onClose)
    }

    func makeView(for state: FoldersCoordinatorState) -> some View {
        FoldersCoordinatorView(state: state)
    }
}

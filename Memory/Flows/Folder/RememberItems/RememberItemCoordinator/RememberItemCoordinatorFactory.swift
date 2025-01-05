//
//  RememberItemCoordinatorFactory.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI

struct RememberItemCoordinatorFactory {
    func makeState(route: RememberItemRouter, onClose: @escaping () -> ()) -> RememberItemCoordinatorState {
        RememberItemCoordinatorState(route: route, onClose: onClose)
    }

    func makeView(for state: RememberItemCoordinatorState) -> some View {
        RememberItemCoordinatorView(state: state)
    }
}

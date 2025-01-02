//
//  LearnCoordinatorFactory.swift
//  Memory
//

import SwiftUI

struct LearnCoordinatorFactory {
    func makeState(route: LearnRoute, onClose: @escaping () -> Void) -> LearnCoordinatorState {
        LearnCoordinatorState(route: route, onClose: onClose)
    }

    func makeView(for state: LearnCoordinatorState) -> some View {
        LearnCoordinatorView(state: state)
    }
}

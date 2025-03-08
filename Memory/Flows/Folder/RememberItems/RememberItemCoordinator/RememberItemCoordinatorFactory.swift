//
//  RememberItemCoordinatorFactory.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI

protocol RememberItemCoordinatorFactoryProtocol {
    func makeState(
        route: RememberItemRouter,
        onClose: @escaping () -> ()
    ) -> RememberItemCoordinatorState
}

//
//  FoldersCoordinatorFactory.swift
//  Memory
//

import SwiftUI

protocol FoldersCoordinatorFactoryProtocol {
    func makeState(
        for route: FoldersRoute,
        onClose: (() -> ())?
    ) -> FoldersCoordinatorState
}

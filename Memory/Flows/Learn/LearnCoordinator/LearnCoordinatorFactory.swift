//
//  LearnCoordinatorFactory.swift
//  Memory
//

protocol LearnCoordinatorFactoryProtocol {
    func makeState(
        for route: LearnRoute,
        onClose: (() -> ())?
    ) -> LearnCoordinatorState
}

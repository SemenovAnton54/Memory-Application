//
//  DefaultStateMachine.swift
//  Memory
//

import SwiftUI
import Combine

final class DefaultStateMachine<State, Event, ViewState>: StateMachine {
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let stateSubject: CurrentValueSubject<State, Never>

    private var cancellable: Set<AnyCancellable> = []

    @Published var viewState: ViewState

    init(
        initialState: State,
        reduce: @escaping (inout State, Event) -> Void,
        present: @escaping (State) -> ViewState,
        feedback: [FeedbackLoop<State, Event>] = []
    ) {
        stateSubject = CurrentValueSubject(initialState)
        viewState = present(initialState)

        Publishers.MergeMany(feedback.map { $0(stateSubject.eraseToAnyPublisher()) })
            .sink { [weak self] event in
                self?.eventSubject.send(event)
            }
            .store(in: &cancellable)

        eventSubject
            .withLatestFrom(stateSubject)
            .receive(on: DispatchQueue.main)
            .map { event, state in
                var state = state
                reduce(&state, event)

                return state
            }
            .eraseToAnyPublisher()
            .assign(to: \.value, on : stateSubject)
            .store(in: &cancellable)

        stateSubject.map {
            present($0)
        }
        .assign(to: &$viewState)
    }

    func event(_ event: Event) {
        eventSubject.send(event)
    }
}

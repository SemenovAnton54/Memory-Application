//
//  StateMachine.swift
//  Memory
//

import Combine

protocol StateMachine: ObservableObject {
    associatedtype ViewState
    associatedtype Event

    var viewState: ViewState { get }

    func event(_ event: Event)
}

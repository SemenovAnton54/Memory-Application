//
//  MemorizeStore.swift
//  Memory
//

import Combine

protocol MemorizeStore: ObservableObject {
    associatedtype ViewState
    associatedtype Event

    var viewState: ViewState { get }

    func event(_ event: Event)
}

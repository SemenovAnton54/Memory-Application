//
//  AppEventsServiceProtocol.swift
//  Memory
//

import Combine

protocol AppEvent {

}

protocol AppEventsClientProtocol {
    func subscribe<Event: AppEvent>(for eventType: Event.Type) -> AnyPublisher<Event, Never>
    func emit<Event: AppEvent>(_ event: Event, receiveOwnEvent: Bool)
}

extension AppEventsClientProtocol {
    func emit<Event: AppEvent>(_ event: Event) {
        emit(event, receiveOwnEvent: false)
    }
}

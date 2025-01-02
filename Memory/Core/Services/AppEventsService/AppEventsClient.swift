//
//  AppEventService.swift
//  Memory
//

import Combine
import Foundation

final class AppEventFactory {
    func makeClient() -> AppEventsClientProtocol {
        let uuid = UUID()
        return AppEventsClient(senderId: uuid, passthroughSubject: passthroughSubject)
    }

    private let passthroughSubject =  PassthroughSubject<AppEventModel, Never>()
}

struct AppEventModel {
    let id: UUID?
    let event: Any
}

struct AppEventsClient: AppEventsClientProtocol {
    let senderId: UUID
    let passthroughSubject: PassthroughSubject<AppEventModel, Never>

    func subscribe<Event: AppEvent>(for eventType: Event.Type) -> AnyPublisher<Event, Never> {
        passthroughSubject.filter { [senderId] record in
            record.id != senderId
        }
        .map(\.event)
        .compactMap {
            $0 as? Event
        }
        .eraseToAnyPublisher()
    }

    func emit<Event: AppEvent>(_ event: Event, receiveOwnEvent: Bool) {
        let eventModel = AppEventModel(id: receiveOwnEvent ? nil : senderId, event: event)

        passthroughSubject.send(eventModel)
    }
}

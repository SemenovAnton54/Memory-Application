//
//  RoutingStateProtocol.swift
//  Memory
//

import Combine

// MARK: - Routing loop

typealias RoutingEvent<Event> = (Event) -> Void
typealias RoutingRequestClosure<Router, Event> = (Router, @escaping RoutingEvent<Event>) -> Void
typealias RoutingFeedbackRequest<Router, Event> = FeedbackRequest<RoutingRequestClosure<Router, Event>>

protocol RoutingStateProtocol {
    associatedtype Router
    associatedtype Event
    var routingRequest: RoutingFeedbackRequest<Router, Event>? { get set }
}

extension RoutingStateProtocol {
    mutating func requestRoute(_ trigger: @escaping RoutingRequestClosure<Router, Event>) {
        routingRequest = RoutingFeedbackRequest(trigger)
    }

    mutating func requestRoute(_ trigger: @escaping (Router) -> Void) {
        routingRequest = RoutingFeedbackRequest { router, _ in trigger(router) }
    }
}

func makeRoutingLoop<State: RoutingStateProtocol>(
    router: State.Router
) -> FeedbackLoop<State, State.Event> {
    react(request: \.routingRequest) { trigger in
        Future<State.Event, Never> { promise in
            trigger(router) { event in
                promise(.success(event))
            }
        }.eraseToAnyPublisher()
    }
}

//
//  performRouterRequest.swift
//  Memory
//

@testable import Memory

func performRouterRequest<State: RoutingStateProtocol, Router>(
    from state: State,
    to router: Router,
    eventHandler: ((State.Event) -> ())? = nil
) where Router == State.Router {
    state.routingRequest?.payload(router) { event in
        eventHandler?(event)
    }
}

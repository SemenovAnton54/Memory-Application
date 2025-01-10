//
//  FeedbackRequest.swift
//  Memory
//

import Foundation
import Combine

struct FeedbackRequest<Payload>: Hashable {
    private let id: UUID
    let payload: Payload

    init(_ payload: Payload) {
        self.id = UUID()
        self.payload = payload
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FeedbackRequest where Payload == Void {
    init() {
        self.init(())
    }
}

private struct ConstHashable<Value: Equatable>: Hashable {
    var value: Value

    func hash(into hasher: inout Hasher) { }
}

typealias FeedbackLoop<State, Event> = (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>

func feedbackLoop<State, Event>(_ closure: @escaping FeedbackLoop<State, Event>) -> FeedbackLoop<State, Event> {
    closure
}

func react<State, Event, Request>(
    request keyPath: KeyPath<State, FeedbackRequest<Request>?>,
    effects: @escaping (Request) -> AnyPublisher<Event, Never>
) -> FeedbackLoop<State, Event> {
    react(request: { $0[keyPath: keyPath] }) { request in
        effects(request.payload)
    }
}

func react<State, Event, Request>(
    request keyPath: KeyPath<State, FeedbackRequest<Request>?>,
    effects: @escaping (Request) async -> Event
) -> FeedbackLoop<State, Event> {
    react(request: { $0[keyPath: keyPath] }) { request in
        await effects(request.payload)
    }
}

func react<State, Request: Equatable, Event>(
    request: @escaping (State) -> Request?,
    effects: @escaping (Request) async -> Event
) -> (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never> {
    return { state in
        let subject = CustomPassthroughSubject<Event, Never>()
        var currentRequest: Request?
        var cancellableRequest: AnyCancellable?

        state.sink { [weak subject] state in
            let newRequest = request(state)

            guard let newRequest else {
                currentRequest = nil
                return
            }

            guard newRequest != currentRequest else {
                return
            }

            currentRequest = newRequest
            cancellableRequest?.cancel()
            cancellableRequest = TaskPublisher {
                await effects(newRequest)
            }
            .sink(receiveValue: {
                subject?.send($0)
            })
        }
        .store(in: &subject.cancellable)

        return subject.eraseToAnyPublisher()
    }
}

func react<State, Request: Equatable, Event>(
    request: @escaping (State) -> Request?,
    effects: @escaping (Request) -> AnyPublisher<Event, Never>
) -> (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never> {
    return { state in
        let subject = CustomPassthroughSubject<Event, Never>()
        var currentRequest: Request?
        var cancellableRequest: AnyCancellable?

        state.sink { [weak subject] state in
            let newRequest = request(state)

            guard let newRequest else {
                currentRequest = nil
                return
            }

            guard newRequest != currentRequest else {
                return
            }

            currentRequest = newRequest
            cancellableRequest?.cancel()
            cancellableRequest = effects(newRequest)
                .sink(receiveValue: {
                    subject?.send($0)
                })
        }
        .store(in: &subject.cancellable)

        return subject.eraseToAnyPublisher()
    }
}


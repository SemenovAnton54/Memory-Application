//
//  CustomPassthroughSubject.swift
//  Memory
//

import Combine

final class CustomPassthroughSubject<Output, Failure: Error>: Publisher {
    var cancellable: Set<AnyCancellable> = []

    private var subscribers = [AnySubscriber<Output, Failure>]()

    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        subscribers.append(AnySubscriber(subscriber))
        subscriber.receive(subscription: InnerSubscription(subscriber: subscriber, subject: self))
    }

    func send(_ value: Output) {
        subscribers.forEach { _ = $0.receive(value) }
    }

    func send(completion: Subscribers.Completion<Failure>) {
        subscribers.forEach { $0.receive(completion: completion) }
        subscribers.removeAll()
    }

    private class InnerSubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
        private var subscriber: S?
        private var subject: CustomPassthroughSubject?

        init(subscriber: S, subject: CustomPassthroughSubject) {
            self.subscriber = subscriber
            self.subject = subject
        }

        func request(_ demand: Subscribers.Demand) {

        }

        func cancel() {
            subscriber = nil
        }
    }
}

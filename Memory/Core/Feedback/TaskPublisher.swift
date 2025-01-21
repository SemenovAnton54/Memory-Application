//
//  TaskPublisher.swift
//  Memory
//

import Combine

struct TaskPublisher<Output: Sendable>: Publisher {
    typealias Failure = Never

    let work: () async -> Output

    nonisolated init(work: @escaping () async -> Output) {
        self.work = work
    }

    func receive<S>(subscriber: S) where S: Subscriber & Sendable, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = TaskSubscription(work: work, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
        subscription.start()
    }

    final class TaskSubscription<TaskOutput: Sendable, Downstream: Subscriber & Sendable>
    : Combine.Subscription, @unchecked Sendable
    where Downstream.Input == TaskOutput, Downstream.Failure == Never
    {
        private var handle: Task<TaskOutput, Never>?
        private let work: () async -> TaskOutput
        private let subscriber: Downstream

        init(work: @escaping () async -> TaskOutput, subscriber: Downstream) {
            self.work = work
            self.subscriber = subscriber
        }

        func start() {
            self.handle = Task { [self, work] in
                let result = await work()
                self.makeRequestCombine(result: result)
                return result
            }
        }

        func makeRequestCombine(result: TaskOutput) {
            _ = subscriber.receive(result)
            subscriber.receive(completion: .finished)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            handle?.cancel()
        }
    }
}


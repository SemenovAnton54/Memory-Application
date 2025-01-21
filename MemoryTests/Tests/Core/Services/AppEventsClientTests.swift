//
//  AppEventsClientTests.swift
//  Memory
//
//  Created by Anton Semenov on 21.01.2025.
//

import Testing
import Combine
import Foundation

@testable import Memory

@Suite("AppEventsService Tests")
struct AppEventsClientTests {
    enum TestEvent: AppEvent {
        case eventOne
        case eventTwo
    }

    let client = AppEventFactory().makeClient()

    @Test("emit and get events")
    func sentEventAndReceiveValue() {
        let subscriber = client.subscribe(for: TestEvent.self)
        var event: TestEvent?

        let cancellable = subscriber.sink {
            event = $0
        }

        client.emit(TestEvent.eventOne, receiveOwnEvent: true)

        #expect(event == .eventOne)
        #expect(cancellable != nil)
    }

    @Test("emit event")
    func sentEventNotReceiveValue() {
        let subscriber = client.subscribe(for: TestEvent.self)
        var event: TestEvent?

        let cancellable = subscriber.sink {
            event = $0
        }

        client.emit(TestEvent.eventOne, receiveOwnEvent: false)

        #expect(event == nil)
        #expect(cancellable != nil)
    }
}

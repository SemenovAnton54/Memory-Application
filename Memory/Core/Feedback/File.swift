//
//  File.swift
//  Memory
//

func feedbackLoop<State, Event>(_ closure: @escaping FeedbackLoop<State, Event>) -> FeedbackLoop<State, Event> {
    closure
}

//___FILEHEADER___

struct ___VARIABLE_productName:identifier___Factory {
    struct Dependencies {
    }

    let dependencies: Dependencies

    func makeStore(
        router: ___VARIABLE_productName:identifier___RouterProtocol
    ) -> DefaultMemorizeStore<___VARIABLE_productName:identifier___State, ___VARIABLE_productName:identifier___Event, ___VARIABLE_productName:identifier___ViewState> {
        let store = DefaultMemorizeStore(
            initialState: ___VARIABLE_productName:identifier___State(),
            reduce: ___VARIABLE_productName:identifier___Reducer().reduce,
            present: ___VARIABLE_productName:identifier___Presenter().present,
            feedback: [

            ]
        )

        return store
    }
}

// MARK: - Feedback loops

typealias ___VARIABLE_productName:identifier___FeedbackLoop = FeedbackLoop<___VARIABLE_productName:identifier___State, ___VARIABLE_productName:identifier___Event>

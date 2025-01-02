//___FILEHEADER___

struct ___VARIABLE_productName:identifier___Reducer {
    func reduce(state: inout ___VARIABLE_productName:identifier___State, event: ___VARIABLE_productName:identifier___Event) {
        switch event {
        case .close:
            onClose(state: &state)
        }
    }
}

// MARK: - Event handlers

private extension ___VARIABLE_productName:identifier___Reducer {
    func onClose(state: inout ___VARIABLE_productName:identifier___State) {
        state.requestRoute {
            $0.close()
        }
    }
}

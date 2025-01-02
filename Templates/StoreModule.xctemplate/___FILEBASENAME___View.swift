//___FILEHEADER___

import SwiftUI
import Combine

struct ___VARIABLE_productName:identifier___View<T: MemorizeStore>: View where T.ViewState == ___VARIABLE_productName:identifier___ViewState, T.Event == ___VARIABLE_productName:identifier___Event {
    @ObservedObject var store: T

    init(store: T) {
        self.store = store
    }

    var body: some View {
        Text("NewScreen")
    }
}

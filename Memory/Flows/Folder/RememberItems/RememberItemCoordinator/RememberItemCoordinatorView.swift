//
//  RememberItemCoordinatorView.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI

struct RememberItemCoordinatorView: View {
    @ObservedObject var state: RememberItemCoordinatorState

    var body: some View {
        linkDestination(link: state.route)
            .navigationDestination(item: $state.nextItem) {
                switch $0 {
                default:
                    if let state = state.nextItemCoordinatorState(for: $0) {
                        RememberItemCoordinatorFactory().makeView(for: state)
                    } else {
                        EmptyView()
                    }

                }
            }
            .sheet(item: $state.presentedItem, content: sheetContent)
    }

    @ViewBuilder func sheetContent(item: RememberItemRouter) -> some View {
        NavigationStack {
            switch item {
            case let .imagePicker(text, completion):
                ImagePickerFactory.makeView(for: state.imagePickerStore(text: text, completion: completion))
            default:
                EmptyView()
            }
        }
    }

    @ViewBuilder func linkDestination(link: RememberItemRouter) -> some View {
        switch link {
        case let .editWordRememberItem(id, categoriesIds):
            EditWordRememberItemView(
                store: state.editWordRememberItemStore(
                    id: id,
                    categoriesIds: categoriesIds
                )
            )
        default:
            EmptyView()
        }
    }
}

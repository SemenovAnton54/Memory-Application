//
//  ImagePickerView.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI
import Combine
import PhotosUI

struct ImagePickerView<T: StateMachine>: View where T.ViewState == ImagePickerViewState, T.Event == ImagePickerEvent {
    @ObservedObject var store: T

    @StateObject private var searchViewModel = SearchViewModel()

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            ScrollView {
                ImagesSectionView(
                    title: "Images from Gallery",
                    emptyListTitle: "No images selected",
                    isLoading: false,
                    imagesStates: store.viewState.customImages.map {
                        .init(
                            imageViewModel: $0,
                            isSelected: true
                        )
                    },
                    onImageTap: {
                        store.event(.removeImageFromGallery(id: $0.id))
                    }
                )

                ImagesSectionView(
                    title: "Images from Bypixel",
                    emptyListTitle: "No images found",
                    isLoading: store.viewState.isLoading,
                    imagesStates: store.viewState.imagesStates,
                    onImageTap: {
                        store.event(.toggleImageSelection(id: $0.id))
                    }
                )
            }

            VStack {
                Spacer()
                PhotosPicker(
                    selection: binding(nil) { store.event(.addImagesFromGallery($0)) },
                    matching: .images
                ) {
                    ImagePickerViewButton()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    store.event(.close)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Select") {
                    store.event(.select)
                }
            }
        }
        .searchable(text: $searchViewModel.searchText)
        .background(Colors.background)
        .onChange(of: searchViewModel.debouncedText, initial: false) { _, newValue in
            guard store.viewState.searchText != newValue else {
                return
            }

            store.event(.searchImages(newValue))
        }
        .onChange(of: store.viewState.searchText, initial: true) { _, newValue in
            searchViewModel.searchText = newValue
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}


struct ImagePickerView_Previews: PreviewProvider {
    class MemorizeMockStore: StateMachine {
        @Published var viewState: ImagePickerViewState

        init() {
            self.viewState = .init(
                searchText: "Some Text",
                customImages: [.init(id: 1, imageType: .systemName("list.clipboard"))],
                imagesStates: [
                    .init(imageViewModel: .init(id: 1, imageType: .systemName("list.clipboard")), isSelected: false),
                    .init(imageViewModel: .init(id: 2, imageType: .systemName("list.clipboard")), isSelected: false),
                    .init(imageViewModel: .init(id: 3, imageType: .systemName("list.clipboard")), isSelected: true),
                    .init(imageViewModel: .init(id: 4, imageType: .systemName("list.clipboard")), isSelected: false),
                    .init(imageViewModel: .init(id: 5, imageType: .systemName("list.clipboard")), isSelected: false),
                    .init(imageViewModel: .init(id: 6, imageType: .systemName("list.clipboard")), isSelected: true),
                    .init(imageViewModel: .init(id: 7, imageType: .systemName("list.clipboard")), isSelected: false),
                    .init(imageViewModel: .init(id: 9, imageType: .systemName("list.clipboard")), isSelected: false),
                    .init(imageViewModel: .init(id: 0, imageType: .systemName("list.clipboard")), isSelected: false),
                ], isLoading: true
            )
        }

        func event(_ event: ImagePickerEvent) {
            print(event)
        }
    }

    static var previews: some View {
        ImagePickerView(store: MemorizeMockStore())
    }
}

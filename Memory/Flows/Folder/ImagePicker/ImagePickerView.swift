//
//  ImagePickerView.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import SwiftUI
import Combine
import PhotosUI

struct ImagePickerView<T: MemorizeStore>: View where T.ViewState == ImagePickerViewState, T.Event == ImagePickerEvent {
    @ObservedObject var store: T

    @StateObject private var searchViewModel = SearchViewModel()

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            ScrollView {
                SecondText("Images from Gallery")
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 0) {
                    ForEach(store.viewState.customImages) { image in
                        GridImageView(image: image, isSelected: true)
                            .onTapGesture {
                                store.event(.removeImageFromGallery(id: image.id))
                            }
                    }
                }

                if store.viewState.customImages.isEmpty {
                    MainText("No images selected")
                        .padding(.bottom, 20)
                }

                SecondText("Images from Bypixel")
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 0) {
                    ForEach(store.viewState.imagesStates) { imageState in
                        GridImageView(image: imageState.imageViewModel, isSelected: imageState.isSelected)
                            .onTapGesture {
                                store.event(.toggleImageSelection(id: imageState.imageViewModel.id))
                            }
                    }
                }

                if store.viewState.isLoading {
                    ProgressView()
                } else if store.viewState.imagesStates.isEmpty {
                    MainText("No images found")
                }
            }

            VStack {
                Spacer()
                PhotosPicker(
                    selection: binding(nil) { store.event(.addImagesFromGallery($0)) },
                    matching: .images
                ) {
                    HStack {
                        Spacer()

                        Image(systemName: "plus.app")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundStyle(Colors.actionColor)
                            .background(Colors.backgroundSecondary)
                            .cornerRadius(20)
                            .padding(20)
                    }
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
    class MemorizeMockStore: MemorizeStore {
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

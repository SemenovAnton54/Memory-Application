//
//  SearchViewModel.swift
//  Memory
//
//  Created by Anton Semenov on 05.01.2025.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var debouncedText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] newText in
                self?.debouncedText = newText
            }
            .store(in: &cancellables)
    }
}

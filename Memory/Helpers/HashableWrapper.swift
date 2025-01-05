//
//  HashableWrapperWrapper.swift
//  Memory
//
//  Created by Anton Semenov on 04.01.2025.
//

import Foundation

struct HashableWrapper<T>: Hashable {
    private let id: UUID

    let value: T
    
    init(_ value: T) {
        self.id = UUID()
        self.value = value
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

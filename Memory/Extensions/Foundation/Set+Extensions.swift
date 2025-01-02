//
// Set+Extensions.swift
//

extension Set {
    func toArray() -> [Element] {
        Array(self)
    }

    mutating func toggleExistence(of element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}

//
// Array+Extensions.swift
//

extension Array where Element: Hashable {
    func uniqueValues() -> Array<Element> {
        Array(Set(self))
    }

    func toSet() -> Set<Element> {
        Set(self)
    }
}

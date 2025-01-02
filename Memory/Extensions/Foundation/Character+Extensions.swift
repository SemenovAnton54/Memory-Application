//
//  Character+Extensions.swift
//  Memory
//

extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
    }

    func toString() -> String {
        String(self)
    }
}

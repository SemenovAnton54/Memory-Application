//
//  String+Extensions.swift
//  Memory
//

extension String {
    func onlyEmoji() -> String {
        return self.filter({ $0.isEmoji })
    }
}

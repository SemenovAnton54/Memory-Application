//
//  RepeatLevel.swift
//  Memory
//

import SwiftUI

enum RepeatLevel: CaseIterable, Comparable, Codable {
    case newItem
    case learning
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    case seventh
    case learned

    var title: String {
        switch self {
        case .newItem:
            return "New Item"
        case .learning:
            return "Learning"
        case .first:
            return "first"
        case .second:
            return "second"
        case .third:
            return "third"
        case .fourth:
            return "fourth"
        case .fifth:
            return "fifth"
        case .sixth:
            return "sixth"
        case .seventh:
            return "seventh"
        case .learned:
            return "Learned"
        }
    }

    var color: Color {
        switch self {
        case .newItem:
            return Color(.purple.withAlphaComponent(0.8))
        case .learning:
            return Color(.white.withAlphaComponent(0.8))
        case .first:
            return Color(.systemRed.withAlphaComponent(0.8))
        case .second:
            return Color(.systemYellow.withAlphaComponent(0.8))
        case .third:
            return Color(.systemOrange.withAlphaComponent(0.8))
        case .fourth:
            return Color(.orange.withAlphaComponent(0.8))
        case .fifth:
            return Color(.systemPurple.withAlphaComponent(0.8))
        case .sixth:
            return Color(.systemTeal.withAlphaComponent(0.8))
        case .seventh:
            return Color(.systemGreen.withAlphaComponent(0.8))
        case .learned:
            return Color(.orange.withAlphaComponent(0.8))
        }
    }

    func next() -> RepeatLevel {
        let allCases = Self.allCases

        guard let selfIndex = allCases.firstIndex(of: self) else {
            return self
        }

        let nextIndex = min(Self.allCases.index(after: selfIndex), Self.allCases.endIndex)

        guard nextIndex != allCases.endIndex else {
            return self
        }

        return allCases[nextIndex]
    }

    func previous() -> RepeatLevel {
        let allCases = Self.allCases

        guard let selfIndex = allCases.firstIndex(of: self) else {
            return self
        }

        let previousIndex = max(Self.allCases.index(before: selfIndex), Self .allCases.startIndex)

        guard previousIndex != allCases.startIndex else {
            return self
        }

        return allCases[previousIndex]
    }
}

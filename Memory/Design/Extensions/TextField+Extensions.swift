//
//  TextField+Extensions.swift
//  Memory
//

import SwiftUI

extension TextField {
    @MainActor
    func defaultStyle() -> some View {
        focusablePadding()
        .background(Colors.backgroundSecondary)
        .cornerRadius(8)
        .foregroundStyle(Colors.text)
        .lineLimit(10)
        .font(.callout)
    }
}

extension View {
    func focusablePadding(_ edges: Edge.Set = .all, _ size: CGFloat? = nil) -> some View {
        modifier(FocusablePadding(edges, size))
    }
}

private struct FocusablePadding : ViewModifier {
    private let edges: Edge.Set
    private let size: CGFloat?
    
    @FocusState private var focused: Bool

    init(_ edges: Edge.Set, _ size: CGFloat?) {
        self.edges = edges
        self.size = size
        self.focused = false
    }

    func body(content: Content) -> some View {
        content
            .focused($focused)
            .padding(edges, size)
            .contentShape(Rectangle())
            .onTapGesture { focused = true }
    }
}

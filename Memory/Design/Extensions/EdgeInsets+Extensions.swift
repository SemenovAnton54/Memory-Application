//
//  EdgeInsets+Extensions.swift
//  Memory
//

import SwiftUI

extension EdgeInsets {
    init(
        top: CGFloat? = nil,
        leading: CGFloat? = nil,
        bottom: CGFloat? = nil,
        trailing: CGFloat? = nil,
        horizontal: CGFloat? = nil,
        vertical: CGFloat? = nil
    ) {
        self.init(
            top: top ?? vertical ?? 0,
            leading: leading ?? horizontal ?? 0,
            bottom: bottom ?? vertical ?? 0,
            trailing: trailing ?? horizontal ?? 0
        )
    }
}

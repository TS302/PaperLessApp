//
//  ListRowTitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct ListRowTitle: ViewModifier {
    let size: CGFloat?

    init(size: CGFloat? = nil) {
        self.size = size
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size ?? 17))
            .fontWeight(.medium)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

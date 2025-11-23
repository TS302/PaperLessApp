//
//  ListRowSubtitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct ListRowSubtitle: ViewModifier {
    let linelimit: Int? = 2
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .lineLimit(linelimit)
            .truncationMode(.tail)
            .foregroundColor(Color.primary.opacity(0.7))
    }
}

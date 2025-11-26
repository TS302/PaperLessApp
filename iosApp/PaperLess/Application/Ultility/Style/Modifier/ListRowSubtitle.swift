//
//  ListRowSubtitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct ListRowSubtitle: ViewModifier {
    let linelimit: Int? = 1
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .lineLimit(linelimit)
            .foregroundStyle(Color.primary)
            .truncationMode(.tail)
    }
}

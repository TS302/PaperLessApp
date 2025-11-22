//
//  ListRowSubtitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct ListRowSubtitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

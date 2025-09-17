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
            .font(AppFonts.subtitle)
            .foregroundColor(Color.appPrimary)
            .opacity(0.7)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

//
//  ListRowSubtitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct SubtitleModi: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(Color.primary)
//            .truncationMode(.tail)
    }
}

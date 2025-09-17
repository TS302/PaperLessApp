//
//  ListRowTitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct ListRowTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(Color.primary)
    }
}

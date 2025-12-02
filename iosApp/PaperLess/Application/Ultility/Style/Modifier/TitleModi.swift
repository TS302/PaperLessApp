//
//  ListRowTitle.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct TitleModi: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .font(.subheadline)
            .truncationMode(.tail)
    }
}

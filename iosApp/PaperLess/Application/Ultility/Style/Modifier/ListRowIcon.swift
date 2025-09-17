//
//  ListRowIcon.swift
//  PaperLess
//
//  Created by Tom Salih on 18.04.25.
//

import SwiftUI

struct ListRowIcon: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundStyle(Color.appPrimary)
    }
}

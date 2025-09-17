//
//  ListItem.swift
//  PaperLess
//
//  Created by Tom Salih on 08.06.25.
//

import SwiftUI

struct ListItem: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.primary)
            .tint(Color.primary)
            .pickerStyle(.menu)
            .padding(.vertical, 5)
            .listRowBackground(Color.secondary)
    }
}

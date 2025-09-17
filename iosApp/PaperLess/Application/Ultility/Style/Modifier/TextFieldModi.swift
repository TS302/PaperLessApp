//
//  TextFieldModi.swift
//  PaperLess
//
//  Created by Tom Salih on 06.06.25.
//

import SwiftUI

struct TextFieldModi: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .fontWeight(.bold)
            .padding(.vertical, 6)
            .foregroundStyle(Color.primary)
            .listRowBackground(Color.secondary)
    }
}

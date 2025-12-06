//
//  CustomStandardButton.swift
//  PaperLess
//
//  Created by Tom Salih on 24.11.25.
//

import SwiftUI

struct CustomStandardButton: View {
    let action: () -> Void
    let Label: String
    let color: Color
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(Label)
                .font(.system(size: 15))
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
                .padding(.horizontal, 40)
                .padding(.vertical, 14)
        }
        .background(color)
        .foregroundStyle(Color.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

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
                .modifier(TitleModi())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .background(color)
        .foregroundStyle(Color.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(.leading, 10)
    }
}

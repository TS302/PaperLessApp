//
//  IconTextFieldRow.swift
//  PaperLess
//
//  Created by Tom Salih on 14.10.25.
//
import SwiftUI

struct IconTextFieldRow: View {
    let systemImageName: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primary.opacity(0.2))
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.primary)
            }

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.words)
        }
    }
}



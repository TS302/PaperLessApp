//
//  EditableTextField.swift
//  PaperLess
//
//  Created by Tom Salih on 04.10.25.
//

import SwiftUI

struct EditableTextField: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Name", text: $text)
                .textFieldStyle(.roundedBorder)
                .disabled(!isEditing)
                .opacity(isEditing ? 1 : 0.7)
            
            Button {
                withAnimation(.easeInOut) {
                    isEditing.toggle()
                }
            } label: {
                Image(systemName:  isEditing ? "checkmark.circle.fill" : "pencil.circle")
                    .foregroundColor(isEditing ? .green : .blue)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
            
            
        }
    }
}

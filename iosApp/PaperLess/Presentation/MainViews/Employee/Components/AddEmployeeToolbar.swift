//
//  AddEmployeeToolbar.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI

struct AddEmployeeToolbar: ToolbarContent {
    @Binding var isPresented: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "person.crop.circle.badge.plus")
                    .foregroundStyle(Color.primary)
            }
        }
    }
}

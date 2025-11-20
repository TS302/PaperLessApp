//
//  EmployeeDetailToolbar.swift
//  PaperLess
//
//  Created by Tom Salih on 20.11.25.
//

import SwiftUI

struct EmployeeDetailToolbar: ToolbarContent {
    @Binding var isPresented: Bool
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(Color.primary)
            }
        }
    }
}

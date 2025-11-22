//
//  RowIcon.swift
//  PaperLess
//
//  Created by Tom Salih on 22.11.25.
//

import SwiftUI

struct RowIcon: View {
    var icon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 40, height: 40)
                .foregroundColor(.primary.opacity(0.2))
            
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.primary)
        }
    }
}

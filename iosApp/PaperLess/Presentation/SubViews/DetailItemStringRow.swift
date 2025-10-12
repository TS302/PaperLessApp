//
//  DetailItemStringRow.swift
//  PaperLess
//
//  Created by Tom Salih on 12.10.25.
//

import SwiftUI

struct DetailItemStringRow: View {
    var text: String = ""
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.primary)
            Text(text)
                .modifier(ListRowTitle())
            
        }
        .padding(.vertical, 4)
    }
}

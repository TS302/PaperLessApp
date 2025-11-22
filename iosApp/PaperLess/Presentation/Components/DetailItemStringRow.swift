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
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primary.opacity(0.2))
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.primary)
            }
            Text(text)
                .modifier(ListRowTitle())
            
        }
    }
}

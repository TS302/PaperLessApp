//
//  SectionHeader.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI

struct SectionHeader: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .modifier(HeadlineModi())
//                .opacity(0.6)
//                .font(.callout)
//                .fontWeight(.black)
//                .foregroundStyle(Color.primary)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, minHeight: 30, alignment: .trailing)
        .padding(.bottom, 8)
    }
}

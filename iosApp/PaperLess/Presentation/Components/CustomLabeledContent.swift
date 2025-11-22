//
//  CustomLabeledContent.swift
//  PaperLess
//
//  Created by Tom Salih on 22.11.25.
//

import SwiftUI

struct CustomLabeledContent: View {
    let label: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .modifier(ListRowSubtitle())
                .padding(.bottom, 2)
            Text(content)
                .modifier(ListRowTitle())
        }
        .padding(.vertical, 2)

    }
}

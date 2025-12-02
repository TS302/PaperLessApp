//
//  HeadlineNodi.swift
//  PaperLess
//
//  Created by Tom Salih on 29.11.25.
//

import SwiftUI

struct HeadlineModi: ViewModifier {
    func body(content: Content) -> some View {
        content
            .opacity(0.8)
            .font(.callout)
            .fontWeight(.black)
            .foregroundStyle(Color.primary)
    }
    
    
    
}


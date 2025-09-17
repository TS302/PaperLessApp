//
//  ListStyle.swift
//  PaperLess
//
//  Created by Tom Salih on 07.06.25.
//

import SwiftUI

struct ListStyle: ViewModifier {
    var title: String
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(Color.secondary)
            .navigationTitle("\(title)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

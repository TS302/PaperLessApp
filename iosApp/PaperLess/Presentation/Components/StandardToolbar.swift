//
//  StandardToolbar.swift
//  PaperLess
//
//  Created by Tom Salih on 01.12.25.
//

import SwiftUI

extension View {
    func standardToolbar(
        title: String? = nil,
        leadingAction: (() -> Void)? = nil,
        leadingIcon: String? = nil,
        leadingIconColor: Color? = nil,
        trailingAction: (() -> Void)? = nil,
        trailingIcon: String? = nil
        
    ) -> some View {
        
        self.toolbar {
            
            if let leadingAction, let icon = leadingIcon {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        leadingAction()
                    } label: {
                        Image(systemName: icon)
                            .foregroundStyle(leadingIconColor ?? Color.primary)
                            .fontWeight(.bold)
                    }
                }
            }
            
            if let title, !title.isEmpty {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .modifier(HeadlineModi())
                        .multilineTextAlignment(.center)
                }
            }
            
            if let trailingAction, let icon = trailingIcon {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        trailingAction()
                    } label: {
                        Image(systemName: icon)
                            .foregroundStyle(Color.primary)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

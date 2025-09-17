//
//  FavoriteNFCTagSegmentPicker.swift
//  PaperLess
//
//  Created by Tom Salih on 23.06.25.
//

import SwiftUI

struct FavoriteNFCTagSegmentPicker: View {
    @Binding var selectedSegment: Int
    
    var body: some View {
        
        HStack {
            Spacer()
            Button {
                selectedSegment = 0
            } label: {
                Image(systemName: "car.fill")
                    .padding(.trailing, 10)
                    .font(.system(size: 16))
                    .foregroundColor(selectedSegment == 0 ? .primary : .primary.opacity(0.4))
            }
            
            Button {
                selectedSegment = 1
            } label: {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .padding(.trailing, 10)
                    .font(.system(size: 16))
                    .foregroundColor(selectedSegment == 1 ? .primary : .primary.opacity(0.4))
            }
            
            Button {
                selectedSegment = 2
            } label: {
                Image(systemName: "key.2.on.ring.fill")
                    .font(.system(size: 16))
                    .foregroundColor(selectedSegment == 2 ? .primary : .primary.opacity(0.4))
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FavoriteNFCTagSegmentPicker(selectedSegment: .constant(0))
}

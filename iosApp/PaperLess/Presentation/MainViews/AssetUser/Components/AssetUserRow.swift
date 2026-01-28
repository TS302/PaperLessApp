//
//  AssetUserRow.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI
import Shared


struct AssetUserRow: View {
    var assetUser: AssetUser
    
    var body: some View {
        
        HStack(spacing: 12) {
            RowIcon(icon: "person.fill")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(assetUser.name)
                    .modifier(TitleModi())
                    .fontWeight(.medium)
                    .foregroundStyle(Color.primary)
            }
        }
    }
}

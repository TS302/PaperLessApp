//
//  AssignAssetContentSection.swift
//  PaperLess
//
//  Created by Tom Salih on 28.11.25.
//

import SwiftUI
import Shared

struct AssignAssetEmployeeListSection: View {
    let assetUserList: [AssetUser]
    let onAssetUserTap: (AssetUser) -> Void
    
    var body: some View {
        if assetUserList.isEmpty {
            ContentUnavailableView(
                "Keine Mitarbeiter gefunden",
                systemImage: "person.2.slash"
            )
        } else {
            ForEach(assetUserList, id: \.id) { assetUser in
                Button {
                    onAssetUserTap(assetUser)
                } label: {
                    AssetUserRow(assetUser: assetUser)
                }
            }
        }
    }
}

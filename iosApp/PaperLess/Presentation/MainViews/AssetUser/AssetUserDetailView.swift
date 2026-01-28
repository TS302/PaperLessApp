//
//  AssetUserDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct AssetUserDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var assetUserDetailVM = AssetUserDetailViewModel()
    
    let employeeId: String
    
    @State var isEditSheetPresented = false
    
    var body: some View {
        List {
            Section {
                if let assetUser = assetUserDetailVM.uiState.assetUser {
                    AssetUserDetailSection(
                        name: assetUser.name,
                        phoneNumber: assetUser.phoneNumber,
                        email: assetUser.email,
                        id: employeeId
                    )
                }
            }
            
            Section {
                let assets = assetUserDetailVM.uiState.assignedItems
                if assets.isEmpty {
                    NoAssignedAssetsView(
                        title: "Keine Items zugewiesen",
                        description: "Diesem Asset-Nutzer sind aktuell keine Assets zugewiesen.",
                        icon: "shippingbox"
                        
                    )
                } else {
                    ForEach(assets, id: \.id) { asset in
                        AssetUserAssignedItemRow(
                            title: asset.displayName,
                            subTitle: asset.code,
                            iconType: asset.type,
                            statusColor: asset.status?.color ?? .gray
                        )
                    }
                }
            }
        }
        .modifier(ListStyle())
        .standardToolbar(
            title: assetUserDetailVM.uiState.assetUser?.name ?? "Asset-User Details",
            trailingAction: { isEditSheetPresented.toggle() },
            trailingIcon: "slider.horizontal.3"
        )
        .sheet(isPresented: $isEditSheetPresented) {
            if let assetUser = assetUserDetailVM.uiState.assetUser {
                EditAssetUserSheet(assetUser: assetUser)
                    .presentationDetents([.medium])
            }
        }
        .onChange(of: isEditSheetPresented) { _, isPresented in
            if !isPresented {
                assetUserDetailVM.load(idString: employeeId)
            }
        }
        .task {
            assetUserDetailVM.load(idString: employeeId)
        }
    }
}

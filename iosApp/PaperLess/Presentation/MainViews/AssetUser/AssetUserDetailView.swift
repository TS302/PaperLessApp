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
    @StateViewModel private var assetUserDetailVM = EmployeeDetailViewModel()
    
    let employeeId: String
    
    @State var isEditSheetPresented = false
    
    var body: some View {
        List {
            Section {
                if let employee = assetUserDetailVM.uiState.employee {
                    EmployeeIDCardView(
                        name: employee.name,
                        phoneNumber: employee.phoneNumber,
                        email: employee.email,
                        id: employeeId
                    )
                }
            }
            Section {
                let items = assetUserDetailVM.uiState.assignedItems
                if items.isEmpty {
                    NoAssignedAssetsView(
                        title: "Keine Items zugewiesen",
                        description: "Diesem Mitarbeiter sind aktuell keine Assets zugewiesen.",
                        icon: "shippingbox"
                        
                    )
                } else {
                    ForEach(items, id: \.id) { item in
                        EmployeeAssignedItemRow(
                            title: item.displayName,
                            subTitle: item.code,
                            iconType: item.type,
                            statusColor: item.status?.color ?? .gray
                        )
                    }
                }
            }
        }
        .modifier(ListStyle())
        .standardToolbar(
            title: assetUserDetailVM.uiState.employee?.name ?? "Mitarbeiter Details",
            leadingAction: { dismiss() },
            leadingIcon: "arrow.left.circle",
            trailingAction: { isEditSheetPresented.toggle() },
            trailingIcon: "slider.horizontal.3"
        )
        .sheet(isPresented: $isEditSheetPresented) {
            if let employee = assetUserDetailVM.uiState.employee {
                EditEmployeeSheet(employee: employee)
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

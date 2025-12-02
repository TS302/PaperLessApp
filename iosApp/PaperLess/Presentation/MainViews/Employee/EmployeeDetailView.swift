//
//  EmployeeDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct EmployeeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var employeeDetailVM = EmployeeDetailViewModel()
    
    let employeeId: String
    
    @State var isEditSheetPresented = false
    
    var body: some View {
        List {
            Section {
                if let employee = employeeDetailVM.uiState.employee {
                    EmployeeIDCardView(
                        name: employee.name,
                        phoneNumber: employee.phoneNumber,
                        email: employee.email,
                        id: employeeId
                    )
                }
            }
            
            Section {
                let items = employeeDetailVM.uiState.assignedItems
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
            title: employeeDetailVM.uiState.employee?.name ?? "Mitarbeiter Details",
            leadingAction: { dismiss() },
            leadingIcon: "arrow.left.circle",
            trailingAction: { isEditSheetPresented.toggle() },
            trailingIcon: "slider.horizontal.3"
        )
        .sheet(isPresented: $isEditSheetPresented) {
            if let employee = employeeDetailVM.uiState.employee {
                EditEmployeeSheet(employee: employee)
            }
        }
        .onChange(of: isEditSheetPresented) { _, isPresented in
            if !isPresented {
                employeeDetailVM.load(idString: employeeId)
            }
        }
        .task {
            employeeDetailVM.load(idString: employeeId)
        }
    }
}

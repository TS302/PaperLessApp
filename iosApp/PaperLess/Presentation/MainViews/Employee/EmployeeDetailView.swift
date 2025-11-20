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
    let employeeId: String
    @StateViewModel private var employeeDetailVM = EmployeeDetailViewModel()
    
    @State var isEditSheetPresented = false
    
    var body: some View {
        List {
            Section("Mitarbeiter") {
                if let employee = employeeDetailVM.uiState.employee {
                    EmployeeDetailsSection(employee: employee)
                }
            }
            Section("Zugewiesene Assets") {
                let items = employeeDetailVM.uiState.assignedItems
                if items.isEmpty {
                    NoAssignedAssetsView()
                } else {
                    ForEach(items, id: \.id) { item in
                        EmployeeAssignedItemRow(
                            displayName: item.displayName,
                            code: item.code,
                            type: item.type,
                            statusColor: item.status?.color ?? .gray
                        )
                    }
                }
            }
        }
        .modifier(ListStyle(title: ""))
        .toolbar {
            EmployeeDetailToolbar(isPresented: $isEditSheetPresented)
        }
        .sheet(isPresented: $isEditSheetPresented) {
            EditEmployeeSheet()
        }
        .task {
            employeeDetailVM.load(idString: employeeId)
        }
    }
}

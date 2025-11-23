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
        .toolbar {
            EmployeeDetailToolbar(isPresented: $isEditSheetPresented)
        }
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

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
            Section("Zugewiesene Items") {
                let items = employeeDetailVM.uiState.assignedItems
                if items.isEmpty {
                    ContentUnavailableView(
                        "Keine Items zugewiesen",
                        systemImage: "shippingbox",
                        description: Text("Diesem Mitarbeiter sind aktuell keine Assets zugewiesen.")
                    )
                    .foregroundStyle(Color.primary)
                } else {
                    ForEach(items, id: \.id) { item in
                        
                        EmployeeAssignedItemRow(
                            displayName: item.displayName,
                            code: item.code,
                            type: item.type,
                            status: item.statusText
                        )
                    }
                }
            }
        }
        .modifier(ListStyle(title: ""))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isEditSheetPresented.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .sheet(isPresented: $isEditSheetPresented) {
            EditEmployeeSheet()
        }
        .task {
            employeeDetailVM.load(idString: employeeId)
        }
        .sheet(isPresented: $isEditSheetPresented) {
            EditEmployeeSheet()
        }
    }
}

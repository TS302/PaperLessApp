//
//  StaffView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync


struct EmployeesView: View {
    @StateViewModel var employeesVM = EmployeesViewModel()
    
    @State private var searchText: String = ""
    @State private var addEmployeeSheetIsPresent: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(employeesVM.uiState.items, id: \.idString) { employee in
                        NavigationLink {
                            EmployeeDetailView(employeeId: employee.idString)
                        } label: {
                            EmployeeRow(employee: employee)
                        }
                    }
                } header: {
                    SectionHeader(text: "Asset-Nutzer")
                }
            }
            .modifier(ListStyle())
            .standardToolbar(
                trailingAction: { addEmployeeSheetIsPresent.toggle() },
                trailingIcon: "person.crop.circle.badge.plus"
            )
        }
        .sheet(isPresented: $addEmployeeSheetIsPresent) {
            AddEmployeeSheet()
                .presentationDetents([.medium])
        }
        .searchable(text: $searchText, prompt: Text("Suchen"))
        .onChange(of: searchText) { _, newValue in
            employeesVM.setSearchQueryForIos(searchText: newValue)
        }
    }
}

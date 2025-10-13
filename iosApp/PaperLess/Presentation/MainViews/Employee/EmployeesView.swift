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

private extension Employee {
    var idString: String { String(describing: id) }
}

struct EmployeesView: View {
    @StateViewModel var employeesVM: EmployeesViewModel
    
    init() {
        _employeesVM = StateViewModel(
            wrappedValue: KoinStarter.shared.employeesViewModel()
        )
    }
    
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
                    SectionHeader(text: "Mitarbeiter")
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        addEmployeeSheetIsPresent.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
            .modifier(ListStyle(title: ""))
            
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

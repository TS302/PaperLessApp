//
//  AssignAssetSheet.swift
//  PaperLess
//
//  Created by Tom Salih on 11.10.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssignAssetSheet: View {
    
    let itemIdString: String
    let onClose: () -> Void
    
    @StateViewModel private var vm = AssignAssetViewModel()
    
    @State private var searchText: String = ""
    
    private var selectedEmployee: Employee? {
        guard let selectedId = vm.uiState.selectedEmployeeId else { return nil }
        return vm.uiState.employees.first {
            String(describing: $0.id) == String(describing: selectedId)
        }
    }
    
    var body: some View {
        NavigationStack {
            AssignAssetContent(
                searchText: $searchText,
                uiState: vm.uiState,
                onClose: onClose,
                onEmployeeTapped: { employee in
                    vm.onEmployeeTapped(employee: employee)
                }
            )
        }
        .onAppear {
            vm.attach(itemIdString: itemIdString)
        }
        .onChange(of: vm.uiState.didAssignSuccessfully) { _, ok in
            if ok { onClose() }
        }
        .assignAssetDialog(
            uiState: vm.uiState,
            selectedEmployee: selectedEmployee,
            confirmAssign: vm.confirmAssign,
            confirmReassign: vm.confirmReassign,
            cancelDialog: vm.cancelDialog
        )
    }
}



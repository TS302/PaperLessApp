//
//  AssignAssetContentSection.swift
//  PaperLess
//
//  Created by Tom Salih on 28.11.25.
//

import SwiftUI
import Shared

struct AssignAssetContentSection: View {
    let employeeList: [Employee]
    let onEmployeeTap: () -> Void
    
    var body: some View {
     if employeeList.isEmpty {
            ContentUnavailableView(
                "Keine Mitarbeiter gefunden",
                systemImage: "person.2.slash"
            )
        } else {
            ForEach(employeeList, id: \.id) { employee in
                Button {
                    onEmployeeTap()
                } label: {
                    EmployeeRow(employee: employee)
                }
            }
        }
    }
}

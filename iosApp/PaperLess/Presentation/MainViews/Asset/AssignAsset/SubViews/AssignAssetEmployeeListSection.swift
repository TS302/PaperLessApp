//
//  AssignAssetContentSection.swift
//  PaperLess
//
//  Created by Tom Salih on 28.11.25.
//

import SwiftUI
import Shared

struct AssignAssetEmployeeListSection: View {
    let employeeList: [Employee]
    let onEmployeeTap: (Employee) -> Void
    
    var body: some View {
        if employeeList.isEmpty {
            ContentUnavailableView(
                "Keine Mitarbeiter gefunden",
                systemImage: "person.2.slash"
            )
        } else {
            ForEach(employeeList, id: \.id) { employee in
                Button {
                    onEmployeeTap(employee)
                } label: {
                    EmployeeRow(employee: employee)
                }
            }
        }
    }
}

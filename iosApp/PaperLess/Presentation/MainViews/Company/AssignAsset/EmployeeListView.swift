//
//  EmployeeListView.swift
//  PaperLess
//
//  Created by Tom Salih on 13.11.25.
//

import SwiftUI
import Shared

struct EmployeeListView: View {
    
    let employees: [Employee]
    let onEmployeeTapped: (Employee) -> Void
    
    var body: some View {
        List(employees, id: \.id) { employee in
            Button {
                onEmployeeTapped(employee)
            } label: {
                EmployeeRow(employee: employee)
            }
        }
        .listStyle(.insetGrouped)
    }
}

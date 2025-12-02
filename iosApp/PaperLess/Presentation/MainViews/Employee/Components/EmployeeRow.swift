//
//  EmployeeRow.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI
import Shared


struct EmployeeRow: View {
    var employee: Employee
    
    var body: some View {
        
        HStack(spacing: 12) {
            RowIcon(icon: "person.and.background.dotted")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(employee.name)
                    .modifier(TitleModi())
                
                Text(employee.phoneNumber)
                    .modifier(SubtitleModi())
                
            }
        }
        .padding(.vertical, 4)
    }
}

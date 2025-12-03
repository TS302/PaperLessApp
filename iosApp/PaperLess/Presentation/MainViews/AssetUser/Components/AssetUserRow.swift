//
//  EmployeeRow.swift
//  PaperLess
//
//  Created by Tom Salih on 09.10.25.
//

import SwiftUI
import Shared


struct AssetUserRow: View {
    var employee: Employee
    
    var body: some View {
        
        HStack(spacing: 12) {
            RowIcon(icon: "person")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(employee.name)
                    .modifier(TitleModi())
                    .fontWeight(.medium)
                    .foregroundStyle(Color.primary)
            }
        }
    }
}

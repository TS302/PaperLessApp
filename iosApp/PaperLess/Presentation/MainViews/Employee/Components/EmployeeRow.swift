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
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primary.opacity(0.2))
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.primary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(employee.name)
                    .fontWeight(.semibold)
                Text(employee.phoneNumber)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

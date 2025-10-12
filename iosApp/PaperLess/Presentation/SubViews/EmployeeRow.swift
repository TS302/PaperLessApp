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
        
        HStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary.opacity(0.2))
                        
                    employee.targetType.icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(employee.name)
                        .modifier(ListRowTitle())
                    
                    HStack {
                        Image(systemName: "ellipsis.rectangle.fill")
                            .foregroundStyle(employee.tagStatus.color)
                        
                        Text(employee.tagStatus.displayName)
                            .modifier(ListRowSubtitle())
                    }
                }
                .padding(.leading, 2)
            }
        }
        .padding(.vertical, 4)
    }
}

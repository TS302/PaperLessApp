//
//  EmployeeAssignedItemRow.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI
import Shared

struct EmployeeAssignedItemRow: View {
    let title: String
    let subTitle: String?
    let iconType: String?
    let statusColor: Color
    
    private func sfSymbol(for type: String?) -> String {
        switch (type ?? "").lowercased() {
        case "vehicle": return "car.fill"
        case "tool":    return "wrench.fill"
        case "key":     return "key.fill"
        default:        return "shippingbox.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                
                RowIcon(icon: sfSymbol(for: iconType))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .modifier(ListRowTitle())
                    
                    if let code = subTitle, !code.isEmpty {
                        Text(code)
                            .modifier(ListRowSubtitle())
                    }
                }
            }
            .padding(.vertical, 4)
            
            Spacer()
            
            Image(systemName: "ellipsis.rectangle.fill")
                .foregroundStyle(statusColor)
        }
        .contentShape(Rectangle())
    }
}

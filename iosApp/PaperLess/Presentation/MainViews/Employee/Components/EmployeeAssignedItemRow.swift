//
//  EmployeeAssignedItemRow.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI
import Shared

struct EmployeeAssignedItemRow: View {
    let displayName: String
    let code: String?
    let type: String?
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary.opacity(0.1))
                    
                    Image(systemName: sfSymbol(for: type))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.primary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(displayName)
                        .fontWeight(.semibold)
                    
                    if let code = code, !code.isEmpty {
                        Text(code)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
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

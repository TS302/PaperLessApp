//
//  ConfirmAssignHeaderSection.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//


import SwiftUI
import Shared

struct ConfirmAssignDialogHeaderSection: View {
    let isReassign: Bool
    let fromName: String
    let toName: String
    let assetName: String
    
    var body: some View {
        Section {
            VStack(alignment: .center, spacing: 8) {
                Text(assetName)
                    .modifier(HeadlineModi())
                
                Text(titleText)

                    .font(.footnote)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(subtitleText)
                    .font(.footnote)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Private computed properties
    
    private var iconName: String {
        isReassign
        ? "exclamationmark.triangle.fill"
        : "backpack.sensor.tag.radiowaves.left.and.right.fill"
    }
    
    private var iconColor: Color {
        isReassign ? Color.appYellow : Color.primary
    }
    
    private var titleText: String {
        if isReassign {
            return "Dieses Asset ist bereits \"\(fromName)\" zugeordnet."
        } else {
            return "Dieses Asset wird jetzt \"\(toName)\" zugeordnet."
        }
    }
    
    private var subtitleText: String {
        if isReassign {
            return "Bitte bestätige um es nun an \"\(toName)\" zu übergeben."
        } else {
            return "Bitte bestätige um das Asset zu übergeben."
        }
    }
}

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
            VStack(alignment: .center, spacing: 6) {
                Text(assetName)
                    .modifier(HeadlineModi())
                
                Text(titleText)
                    .modifier(TitleModi())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                Text(subtitleText)
                    .modifier(TitleModi())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            .padding(20)
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
            return "Dieses Asset ist bereits \(fromName) zugewiesen."
        } else {
            return "Dieses Asset wird jetzt \(toName) zugewiesen."
        }
    }
    
    private var subtitleText: String {
        if isReassign {
            return "Bitte bestätige um es nun an \(toName) übergeben."
        } else {
            return "Bitte bestätige um das Asset zu übergeben."
        }
    }
}

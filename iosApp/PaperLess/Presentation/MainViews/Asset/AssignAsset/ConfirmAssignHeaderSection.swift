//
//  ConfirmAssignHeaderSection.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//


import SwiftUI
import Shared

struct ConfirmAssignHeaderSection: View {
    let isReassign: Bool
    let fromName: String
    let toName: String

    var body: some View {
        Section {
            VStack(alignment: .center, spacing: 12) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 38, height: 38)
                    .foregroundStyle(iconColor)

                Text(titleText)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(subtitleText)
                    .font(.footnote)
                    .foregroundStyle(Color.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
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
            return "Dieses Asset jetzt \(toName) zuweisen?"
        }
    }

    private var subtitleText: String {
        if isReassign {
            return "Es wird nun von \(fromName) zu \(toName) übergeben."
        } else {
            return "Bitte bestätige um das Asset zu übergeben."
        }
    }
}

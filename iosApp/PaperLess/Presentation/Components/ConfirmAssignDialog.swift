//
//  ConfirmAssignDialog.swift
//  PaperLess
//
//  Created by Tom Salih on 12.11.25.
//

import SwiftUI

struct ConfirmAssignDialog: View {
    let assetName: String
    let employeeName: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("„\(assetName)“ zuweisen?")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(employeeName)
                .font(.title3)
                .bold()

            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("Abbrechen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.error)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: onConfirm) {
                    Text("Zuweisen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .presentationDetents([.height(200)])
    }
}

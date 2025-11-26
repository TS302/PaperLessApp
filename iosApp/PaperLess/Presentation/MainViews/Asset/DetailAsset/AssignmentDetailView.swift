//
//  AssignmentDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI
import Shared

struct AssignmentDetailView: View {
    let assignment: Assignment
    let employeeName: String
    let from: String
    let until: String?
    
    var body: some View {
        Form {
            Section("Mitarbeiter") {
                VStack {
                    Text("Name")
                        .modifier(ListRowSubtitle())
                    Text(employeeName)
                        .modifier(ListRowTitle())
                }
            }
            
            Section("Zeitraum") {
                VStack {
                    Text("Von")
                        .modifier(ListRowSubtitle())
                    Text(from)
                        .modifier(ListRowTitle())
                }
                Divider()
                VStack {
                    Text("Bis")
                        .modifier(ListRowSubtitle())
                    Text(until ?? "Aktuell")
                        .modifier(ListRowTitle())
                }
            }
            
            if let note = assignment.note, !note.isEmpty {
                Section("Details") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bemerkung")
                            .modifier(ListRowSubtitle())
                        Text(note)
                            .modifier(ListRowTitle())
                    }
                }
            }
        }
        .modifier(ListStyle())
    }
}

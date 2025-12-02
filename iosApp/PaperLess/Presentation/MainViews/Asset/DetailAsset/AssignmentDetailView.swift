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
                        .modifier(SubtitleModi())
                    Text(employeeName)
                        .modifier(TitleModi())
                }
            }
            
            Section("Zeitraum") {
                VStack {
                    Text("Von")
                        .modifier(SubtitleModi())
                    Text(from)
                        .modifier(TitleModi())
                }
                Divider()
                VStack {
                    Text("Bis")
                        .modifier(SubtitleModi())
                    Text(until ?? "Aktuell")
                        .modifier(TitleModi())
                }
            }
            
            if let note = assignment.note, !note.isEmpty {
                Section("Details") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bemerkung")
                            .modifier(SubtitleModi())
                        Text(note)
                            .modifier(TitleModi())
                    }
                }
            }
        }
        .modifier(ListStyle())
    }
}

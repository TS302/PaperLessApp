//
//  AssignmentDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI
import Shared

struct AssignmentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let assignment: Assignment
    let employeeName: String
    let from: String
    let until: String?
    
    var body: some View {
        Form {
            Section {
                HStack {
                    RowIcon(icon: "person.fill")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Name")
                            .modifier(SubtitleModi())
                        Text(employeeName)
                            .modifier(TitleModi())
                    }
                }
                .padding(.vertical, 6)
            }
            
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Von")
                            .modifier(SubtitleModi())
                        Text(from)
                            .modifier(TitleModi())
                    }
                    Spacer()
                    Image(systemName: "chevron.backward.chevron.backward.dotted")
                        .foregroundStyle(Color.primary)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 6)
                
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bis")
                            .modifier(SubtitleModi())
                        
                        Text(until ?? "Aktuell")
                            .modifier(TitleModi())
                    }
                    Spacer()
                    Image(systemName: "chevron.forward.dotted.chevron.forward")
                        .foregroundStyle(Color.primary)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 6)
            }
            
            if let note = assignment.note, !note.isEmpty {
                Section {
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
        .standardToolbar(
            title: employeeName,
            leadingAction: { dismiss() },
            leadingIcon: "arrow.left.circle"
        )
    }
}

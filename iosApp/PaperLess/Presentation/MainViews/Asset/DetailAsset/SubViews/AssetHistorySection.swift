//
//  AssetHistorySection.swift
//  PaperLess
//
//  Created by Tom Salih on 04.12.25.
//

import SwiftUI
import Shared

struct AssetHistorySection: View {
    let lastAssignments: [Assignment]
    let lastAssignees: [AssetUser]
    @State private var showAllHistory = false
    
    var body: some View {
        if lastAssignments.isEmpty {
            Section {
                NoAssignedAssetsView(
                    title: "Keine bisherigen Zuweisungen",
                    description: "Hier siehst du später die letzten Assetnutzer.",
                    icon: "clock.arrow.circlepath"
                )
            }
            
        } else {
            //TODO: 1-3 besser kommentieren
            // 1) aktuelles Assignment (falls vorhanden)
            let current = lastAssignments.first { $0.until == nil }

            // 2) abgeschlossene Assignments: Datum absteigend (neueste zuerst)
            let finishedSorted = lastAssignments
                .filter { $0.until != nil }
                .sorted { $0.from.toDate() > $1.from.toDate() }

            // 3) entweder nur 2 oder alle anzeigen
            let finishedToShow = showAllHistory ? finishedSorted : Array(finishedSorted.prefix(2))

            Section {
                // Aktuell separat oben
                if let current {
                    AssignmentRow(
                        assignment: current,
                        lastAssignees: lastAssignees,
                        isCurrent: true
                    )
                }

                // Letzte 3 (oder alle) darunter
                ForEach(finishedToShow, id: \.id) { assignment in
                    AssignmentRow(
                        assignment: assignment,
                        lastAssignees: lastAssignees,
                        isCurrent: false
                    )
                }

                // Button nur anzeigen, wenn es mehr als 2 abgeschlossene gibt
                if finishedSorted.count > 2 {
                    Button {
                        showAllHistory.toggle()
                    } label: {
                        HStack {
                            Text(showAllHistory ? "Weniger anzeigen" : "Alle anzeigen")
                            Spacer()
                            Image(systemName: showAllHistory ? "chevron.up" : "chevron.down")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

private struct AssignmentRow: View {
    let assignment: Assignment
    let lastAssignees: [AssetUser]
    let isCurrent: Bool

    var body: some View {
        
        let assetUser = lastAssignees.first { $0.id == assignment.assetUserId }
        let name = assetUser?.name ?? "Unbekannter Asset-User"

        let fromDate = assignment.from.toDate()
        let untilDate = assignment.until?.toDate()

        let fromDateText = fromDate.formattedAssignmentDateOnly()
        let untilDateText = untilDate?.formattedAssignmentDateOnly()

        let fromDateTimeText = fromDate.formattedAsAssignment()
        let untilDateTimeText = untilDate?.formattedAsAssignment()

        let periodText: String = {
            if isCurrent {
                return "\(fromDateText) - laufend..."
            }
            if let untilDateText {
                return "\(fromDateText) - \(untilDateText)"
            } else {
                return "\(fromDateText) - aktuell"
            }
        }()

        NavigationLink {
            AssignmentDetailView(
                assignment: assignment,
                employeeName: name,
                from: fromDateTimeText,
                until: untilDateTimeText
            )
        } label: {
            
            HStack(spacing: 12) {
                HistoryAssigneeRow(
                    title: name,
                    periodText: periodText
                )

                Spacer()

                if isCurrent {
                    Text("Aktuell")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(Color.primary)
                        )
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}

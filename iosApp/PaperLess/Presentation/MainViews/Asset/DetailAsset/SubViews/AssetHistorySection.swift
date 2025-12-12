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
            Section {
                ForEach(lastAssignments, id: \.id) { assignment in
                    
                    // passenden Mitarbeiter zu dieser Zuweisung suchen
                    let assetUser = lastAssignees.first { assetUser in
                        assetUser.id == assignment.assetUserId
                    }
                    
                    // Fallback, falls kein Name gefunden wird
                    let name = assetUser?.name ?? "Unbekannter Asset-User"
                    
                    // Instant -> Date → Date
                    let fromDate = assignment.from.toDate()
                    let untilDate = assignment.until?.toDate()
                    
                    // einzelne Strings für Von / Bis nur Datum
                    let fromDateText = fromDate.formattedAssignmentDateOnly()
                    let untilDateText = untilDate?.formattedAssignmentDateOnly()
                    
                    // einzelne Strings für Von / Bis nur Datum
                    let fromDateTimeText = fromDate.formattedAsAssignment()
                    let untilDateTimeText = untilDate?.formattedAsAssignment()
                    
                    // Text für die Liste
                    let periodText: String = {
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
                        HistoryAssigneeRow(
                            title: name,
                            periodText: periodText
                        )
                    }
                }
            }
        }
    }
}

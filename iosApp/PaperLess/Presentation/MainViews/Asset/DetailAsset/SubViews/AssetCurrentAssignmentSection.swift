//
//  AssetCurrentAssignmentSection.swift
//  PaperLess
//
//  Created by Tom Salih on 04.12.25.
//

import SwiftUI
import Shared

struct AssetCurrentAssignmentSection: View {
    let isLoading: Bool
    let currentAssigneeName: String?
    let currentAssigneeId: String?
    let currentAssignmentNote: String?
    let assetIdString: String
    
    var body: some View {
        
        Section {
            if isLoading {
                ProgressView("Zuweisung wird geladen…")
                
            } else if
                let currentName = currentAssigneeName,
                !currentName.isEmpty
            {
                
                if let currentEmployeeId = currentAssigneeId {
                    NavigationLink {
                        AssetUserDetailView(employeeId: currentEmployeeId)
                    } label: {
                        CurrentAssigneeRow(
                            name: currentName,
                            note: currentAssignmentNote
                        )
                    }
                }
                
                
                NavigationLink {
                    AssignAssetView(itemIdString: assetIdString)
                } label: {
                    AssignActionRow(
                        title: "Asset neu verknüpfen",
                        subtitle: "Einem anderen Asset-User zuordnen"
                    )
                }
                
            } else {
                NavigationLink {
                    AssignAssetView(itemIdString: assetIdString)
                } label: {
                    AssignActionRow(
                        title: "Asset verknüpfen",
                        subtitle: "Keinem bestehende Verknüpfung"
                    )
                }
            }
        }
    }
}

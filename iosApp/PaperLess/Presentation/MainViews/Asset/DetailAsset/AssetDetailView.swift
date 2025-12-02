//
//  AssetDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct AssetDetailView: View {
    let asset: NfcTaggable
    var onSaved: ((NfcTaggable) -> Void)? = nil
    
    @StateViewModel var itemDetailVM = AssetDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditSheetPresented = false
    
    private func reload() {
        itemDetailVM.load(assetId: asset.id)
    }
    
    var body: some View {
        NavigationStack {
            List {
                generalInfoSection
                currentAssignmentSection
                historySection
            }
            .modifier(ListStyle())
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isEditSheetPresented, onDismiss: reload) {
                EditAssetSheet(asset: asset)
            }
            .standardToolbar(
                title: itemDetailVM.uiState.asset?.name ?? "",
                leadingAction: { dismiss() },
                leadingIcon: "arrow.left.circle",
                trailingAction: { isEditSheetPresented.toggle() },
                trailingIcon: "slider.horizontal.3"
            )
            .onAppear {
                itemDetailVM.load(assetId: asset.id)
            }
            .onChange(of: itemDetailVM.uiState.operationSucceeded) { _, operationSucceeded in
                if operationSucceeded {
                    let updated = itemDetailVM.uiState.asset ?? asset
                    onSaved?(updated)
                    dismiss()
                }
            }
        }
    }
    
    // MARK: - Unter-Views / Sections
    
    private var displayedAsset: NfcTaggable {
        itemDetailVM.uiState.asset ?? asset
    }
    
    private var generalInfoSection: some View {
        Section {
            if let tool = displayedAsset as? Tool {
                ToolDetailsSection(asset: tool)
            } else if let key = displayedAsset as? KeyRing {
                KeyDetailsSection(asset: key)
            } else if let vehicle = displayedAsset as? Vehicle {
                VehicleDetailsSection(asset: vehicle)
            }
        }
    }
    
    private var currentAssignmentSection: some View {
        Section {
            if itemDetailVM.uiState.isLoading {
                ProgressView("Zuweisung wird geladen…")
                
            } else if
                let currentName = itemDetailVM.uiState.currentAssigneeName,
                !currentName.isEmpty
            {
                
                if let currentEmployeeId = itemDetailVM.uiState.currentAssigneeId {
                    NavigationLink {
                        EmployeeDetailView(employeeId: currentEmployeeId)
                    } label: {
                        CurrentAssigneeRow(
                            name: currentName,
                            note: itemDetailVM.uiState.currentAssignmentNote
                        )
                    }
                }
                
                NavigationLink {
                    AssignAssetView(itemIdString: asset.id.description())
                } label: {
                    AssignActionRow(
                        title: "Neue Zuweisung",
                        subtitle: "Anderer Person zuordnen"
                    )
                }
                
            } else {
                // Noch gar kein Mitarbeiter → direkt zu Auswahl
                NavigationLink {
                    AssignAssetView(itemIdString: asset.id.description())
                } label: {
                    AssignActionRow(
                        title: "Mitarbeiter zuweisen",
                        subtitle: "Keinem Mitarbeiter zugeordnet"
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var historySection: some View {
        if itemDetailVM.uiState.lastAssignments.isEmpty {
            Section {
                NoAssignedAssetsView(
                    title: "Keine bisherigen Zuweisungen",
                    description: "Hier siehst du später die letzten Mitarbeiter.",
                    icon: "clock.arrow.circlepath"
                )
            }
        } else {
            Section {
                ForEach(itemDetailVM.uiState.lastAssignments, id: \.id) { assignment in
                    
                    // passenden Mitarbeiter zu dieser Zuweisung suchen
                    let employee = itemDetailVM.uiState.lastAssignees.first { emp in
                        emp.id == assignment.employeeId
                    }
                    
                    // Fallback, falls kein Name gefunden wird
                    let name = employee?.name ?? "Unbekannter Mitarbeiter"
                    
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

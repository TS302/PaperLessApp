//
//  AssetDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

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
    @State private var isAssignSheetPresented = false
    
    private func reload() {
        itemDetailVM.load(assetId: asset.id)
    }
    
    //    // Formatter für "01.01.25/12:00 Uhr"
    //    private let assignmentDateFormatter: DateFormatter = {
    //        let df = DateFormatter()
    //        df.dateFormat = "dd.MM.yy/HH:mm 'Uhr'"
    //        df.locale = Locale(identifier: "de_DE")
    //        return df
    //    }()
    //
    //    private func format(_ date: Date) -> String {
    //        assignmentDateFormatter.string(from: date)
    //    }
    
    // MARK: - Körper
    
    var body: some View {
        NavigationStack {
            List {
                generalInfoSection
                currentAssignmentSection
                historySection
            }
            .modifier(ListStyle(title: asset.name))
            .sheet(isPresented: $isAssignSheetPresented,onDismiss: reload) {
                AssignAssetSheet(
                    itemIdString: asset.id.description(),
                    onClose: { isAssignSheetPresented = false }
                )
            }
            .sheet(isPresented: $isEditSheetPresented, onDismiss: reload) {
                EditAssetSheet(asset: asset)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isEditSheetPresented.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
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
        } header: {
            SectionHeader(text: "Allgemeine Informationen")
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
                AssignActionRow(
                    title: "Neue Zuweisung",
                    subtitle: "Dieses Objekt einer anderen Person zuordnen.",
                    action: { isAssignSheetPresented = true }
                )
            } else {
                AssignActionRow(
                    title: "Mitarbeiter zuweisen",
                    subtitle: "Dieses Objekt ist aktuell niemandem zugeordnet.",
                    action: { isAssignSheetPresented = true }
                )
            }
        } header: {
            SectionHeader(text: "Aktuelle Zuweisung")
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
            } header: {
                SectionHeader(text: "Vergangene Zuweisungen")
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
            } header: {
                SectionHeader(text: "Vergangene Zuweisungen")
            }
        }
    }
}

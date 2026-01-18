//
//  AssignmentDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 26.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI


struct AssignmentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateViewModel private var vm = AssignmentDetailViewModel()
    
    let assignment: Assignment
    let employeeName: String
    let from: String
    let until: String?
    
    @State private var showReturnConfirm = false
    
    private var isActive: Bool { until == nil } // wenn du "Aktuell" als String übergibst: until == nil || until == "Aktuell"
    
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
            
            if isActive {
                Section {
                    Button(role: .destructive) {
                        showReturnConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.uturn.left")
                            Text(vm.uiState.isCompleting ? "Wird zurückgegeben..." : "Asset zurückgeben")
                        }
                    }
                    .disabled(vm.uiState.isCompleting)
                }
            }
            
            if let error = vm.uiState.errorMessage {
                Section {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
        }
        .modifier(ListStyle())
        .standardToolbar(
            title: employeeName,
            leadingAction: { dismiss() },
            leadingIcon: "arrow.left.circle"
        )
        .confirmationDialog(
            "Asset wirklich zurückgeben?",
            isPresented: $showReturnConfirm,
            titleVisibility: .visible
        ) {
            Button("Zurückgeben", role: .destructive) {
                // jetzt abschließen: until = jetzt
                let nowMillis = Int64(Date().timeIntervalSince1970 * 1000)
                vm.complete(assignmentId: assignment.id, assetId: assignment.tagId, untilMillis: nowMillis)
            }
            Button("Abbrechen", role: .cancel) {}
        }
        .onChange(of: vm.uiState.didComplete) { _, did in
            if did {
                dismiss()
                vm.resetDidComplete()
            }
        }
    }
}

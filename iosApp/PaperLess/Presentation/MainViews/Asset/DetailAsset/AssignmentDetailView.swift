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
    @State private var returnNoteText: String = ""
    
    private var isActive: Bool { until == nil }
    
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
                .padding(.vertical, 4)
            }
            
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Zeitpunkt der Übergabe")
                            .modifier(SubtitleModi())
                        Text(from)
                            .modifier(TitleModi())
                    }
                    Spacer()
                    Image(systemName: "chevron.forward.dotted.chevron.forward")
                        .foregroundStyle(Color.primary)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 4)
                
                if let note = assignment.fromNote, !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bemerkung (Übergabe)")
                            .modifier(SubtitleModi())
                        Text(note)
                            .padding(.trailing, 24)
                            .modifier(TitleModi())
                    }
                }
            }
            
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Zeitpunkt der Rücknahme")
                            .modifier(SubtitleModi())
                        
                        Text(until ?? "ausstehend")
                            .modifier(TitleModi())
                    }
                    Spacer()
                    Image(systemName: "chevron.backward.chevron.backward.dotted")
                        .foregroundStyle(Color.primary)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 4)
                
                if let note = assignment.untilNote, !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bemerkung (Rücknahme)")
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
                            Text(vm.uiState.isCompleting ? "Wird zurückgenommen..." : "Asset zurücknehmen")
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
            title: employeeName
        )
        .alert("Asset wirklich zurücknehmen?", isPresented: $showReturnConfirm) {
            TextField("Kommentar (optional)", text: $returnNoteText)

            Button("Zurücknehmen", role: .destructive) {
                let trimmed = returnNoteText.trimmingCharacters(in: .whitespacesAndNewlines)
                vm.complete(
                    assetIdString: assignment.tagId.description(),
                    untilNote: trimmed.isEmpty ? nil : trimmed
                )
                returnNoteText = ""
            }

            Button("Abbrechen", role: .cancel) {
                returnNoteText = ""
            }
        } message: {
            Text("Du kannst optional einen Kommentar zur Rückgabe hinzufügen.")
        }
        .onChange(of: vm.uiState.didComplete) { _, did in
            if did {
                dismiss()
                vm.resetDidComplete()
            }
        }
    }
}


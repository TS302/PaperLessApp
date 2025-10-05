//
//  ItemDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 27.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct ItemDetailView: View {
    let item: NfcTaggable
    var onSaved: ((NfcTaggable) -> Void)? = nil

    @ObservedViewModel var itemDetailVM: ItemDetailViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedStatusCaseName: String = TagStatus.available.caseName
    @State private var isEditing = false

    init(item: NfcTaggable, onSaved: ((NfcTaggable) -> Void)? = nil) {
        self.item = item
        self.onSaved = onSaved
        self._itemDetailVM = ObservedViewModel(wrappedValue: KoinStarter.shared.itemDetailViewModel())
    }

    private var selectedTagStatus: TagStatus {
        TagStatus.all.first { $0.caseName == selectedStatusCaseName } ?? .available
    }

    private var nameBinding: Binding<String> {
        Binding(
            get: { itemDetailVM.uiState.item?.name ?? item.name },
            set: { itemDetailVM.setNameInState(newName: $0) }
        )
    }

    var body: some View {
        NavigationStack {
            List {
                TextField("Bezeichnung", text: nameBinding)
                    .disabled(!isEditing)

                if isEditing {
                    Picker("Status", selection: $selectedStatusCaseName) {
                        ForEach(TagStatus.all, id: \.caseName) { status in
                            HStack {
                                Circle().fill(status.color).frame(width: 12, height: 12)
                                Text(status.displayName)
                            }
                            .tag(status.caseName)
                        }
                    }
                    .disabled(itemDetailVM.uiState.isSaving || itemDetailVM.uiState.isDeleting)
                    .onChange(of: selectedStatusCaseName) { _, newValue in
                        if let newStatus = TagStatus.all.first(where: { $0.caseName == newValue }) {
                            itemDetailVM.setStatusInState(newStatus: newStatus)
                        }
                    }
                } else {
                    HStack {
                        Text(itemDetailVM.uiState.item?.tagStatus.displayName ?? item.tagStatus.displayName)
                        Spacer()
                        Image(systemName: "ellipsis.rectangle.fill")
                            .foregroundStyle(item.tagStatus.color)
                    }
                    
                }

                if let error = itemDetailVM.uiState.errorMessage {
                    Text(error).foregroundStyle(.red)
                }
                if itemDetailVM.uiState.isSaving {
                    ProgressView("Speichern …")
                }
            }
            .navigationTitle("Details")
            .onAppear {
                itemDetailVM.hydrate(item: item)
                itemDetailVM.start(item: item, refresh: true)
                let current = itemDetailVM.uiState.item?.tagStatus ?? item.tagStatus
                selectedStatusCaseName = current.caseName
            }
            .onChange(of: itemDetailVM.uiState.operationSucceeded) { _, ok in
                if ok {
                    let updated = itemDetailVM.uiState.item ?? item
                    onSaved?(updated)
                    dismiss()
                }
            }
            .onChange(of: itemDetailVM.uiState.item?.tagStatus.caseName) { _, newCase in
                if let newCase { selectedStatusCaseName = newCase }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Fertig" : "Bearbeiten") {
                        if isEditing {
                            if let newStatus = TagStatus.all.first(where: { $0.caseName == selectedStatusCaseName }) {
                                itemDetailVM.setStatusInState(newStatus: newStatus)
                            }
                            itemDetailVM.saveCurrentItem()
                            itemDetailVM.start(item: item, refresh: true)
                            isEditing = false
                        } else {
                            let current = itemDetailVM.uiState.item?.tagStatus ?? item.tagStatus
                            selectedStatusCaseName = current.caseName
                            isEditing = true
                        }
                    }
                }
            }
        }
    }
}

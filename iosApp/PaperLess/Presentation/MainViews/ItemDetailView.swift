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
    
    @StateViewModel var itemDetailVM: ItemDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    //    @State private var selectedStatusCaseName: String = TagStatus.available.caseName
    @State private var isEditing = false
    @State private var isAssignSheetPresented = false
    
    init(item: NfcTaggable, onSaved: ((NfcTaggable) -> Void)? = nil) {
        self.item = item
        self.onSaved = onSaved
        self._itemDetailVM = StateViewModel(wrappedValue: KoinStarter.shared.itemDetailViewModel())
    }
    
    
    //MARK: Bindings
    
    private var nameBinding: Binding<String> {
        Binding(
            get: { itemDetailVM.uiState.item?.name ?? item.name },
            set: { itemDetailVM.setNameInState(newName: $0) }
        )
    }
    
    /// Direktes Binding des Pickers auf den VM-Status (Case-Name als String)
    private var statusCaseNameBinding: Binding<String> {
        Binding(
            get: { itemDetailVM.uiState.item?.tagStatus.caseName ?? item.tagStatus.caseName },
            set: { newCaseName in
                if let newStatus = TagStatus.all.first(where: { $0.caseName == newCaseName }) {
                    itemDetailVM.setStatusInState(newStatus: newStatus)
                }
            }
        )
    }
    
    //    private var selectedTagStatus: TagStatus {
    //        TagStatus.all.first { $0.caseName == selectedStatusCaseName } ?? .available
    //    }
    //
    //    private var nameBinding: Binding<String> {
    //        Binding(
    //            get: { itemDetailVM.uiState.item?.name ?? item.name },
    //            set: { itemDetailVM.setNameInState(newName: $0) }
    //        )
    //    }
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Bezeichnung", text: nameBinding)
                    .disabled(!isEditing)
                
                if isEditing {
                    Picker("Status", selection: statusCaseNameBinding) {
                        ForEach(TagStatus.all, id: \.caseName) { status in
                            HStack {
                                Circle().fill(status.color).frame(width: 12, height: 12)
                                Text(status.displayName)
                            }
                            .tag(status.caseName)
                        }
                    }
                    .disabled(itemDetailVM.uiState.isSaving || itemDetailVM.uiState.isDeleting)
                } else {
                    HStack {
                        Text(itemDetailVM.uiState.item?.tagStatus.displayName ?? item.tagStatus.displayName)
                        Spacer()
                        Image(systemName: "ellipsis.rectangle.fill")
                            .foregroundStyle((itemDetailVM.uiState.item?.tagStatus.color ?? item.tagStatus.color))
                    }
                }
                
                if let error = itemDetailVM.uiState.errorMessage, !error.isEmpty {
                    Text(error).foregroundStyle(.red)
                }
                if itemDetailVM.uiState.isSaving {
                    ProgressView("Speichern…")
                }
            }
            
            
            Button {
                isAssignSheetPresented.toggle()
            } label: {
                Image(systemName: "airtag.fill")
                    .font(.system(size: 160))
                    .padding(.bottom, 120)
                    .foregroundStyle(Color.primary)
            }
            .navigationTitle("Details")
            .sheet(isPresented: $isAssignSheetPresented) {
                if let loaded = itemDetailVM.uiState.item {
                    AssignAssetSheet(
                        itemIdString: loaded.idString,
                        onClose: { isAssignSheetPresented = false },
                        onAssigned: { itemDetailVM.start(item: item, refresh: true) }
                    )
                } else {
                    ProgressView("Item wird geladen…").padding()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Fertig" : "Bearbeiten") {
                        if isEditing {
                            // Speichern & neu laden
                            itemDetailVM.saveCurrentItem()
                            itemDetailVM.start(item: item, refresh: true)
                            isEditing = false
                        } else {
                            isEditing = true
                        }
                    }
                }
            }
            .onAppear {
                // VM initialisieren & ggf. Daten nachladen
                itemDetailVM.hydrate(item: item)
                itemDetailVM.start(item: item, refresh: true)
            }
            .onChange(of: itemDetailVM.uiState.operationSucceeded) { _, ok in
                if ok {
                    let updated = itemDetailVM.uiState.item ?? item
                    onSaved?(updated)
                    dismiss()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary)
    }
}

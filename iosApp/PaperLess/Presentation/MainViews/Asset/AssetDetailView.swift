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

struct AssetDetailView: View {
    let asset: NfcTaggable
    var onSaved: ((NfcTaggable) -> Void)? = nil
    
    @StateViewModel var itemDetailVM = AssetDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditSheetIsPresented = false
    @State private var isAssignSheetPresented = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Allgemeine Informationen") {
                    let displayedAsset = itemDetailVM.uiState.asset ?? asset
                    
                    if let tool = displayedAsset as? Tool {
                        ToolDetailsSection(asset: tool)
                    } else if let key = displayedAsset as? KeyRing {
                        KeyDetailsSection(asset: key)
                    } else if let vehicle = displayedAsset as? Vehicle {
                        VehicleDetailsSection(asset: vehicle)
                    }
                }
                
                Section {
                    if itemDetailVM.uiState.isLoading {
                        ProgressView("Zuweisung wird geladen…")
                    } else {
                        if let currentName = itemDetailVM.uiState.currentAssigneeName,
                           !currentName.isEmpty {
                            
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.primary.opacity(0.2))
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(Color.primary)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currentName)
                                        .fontWeight(.semibold)
                                    Text("Aktuell zugewiesen")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            
                            Button {
                                isAssignSheetPresented = true
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.primary.opacity(0.1))
                                        
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(Color.primary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Neue Zuweisung")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.primary)
                                        
                                        Text("Diesem Objekt eine andere Person zuweisen.")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                            
                        } else {
                            Button {
                                isAssignSheetPresented = true
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.primary.opacity(0.1))
                                        
                                        Image(systemName: "person.badge.plus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(Color.primary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Mitarbeiter zuweisen")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.primary)
                                        
                                        Text("Dieses Objekt ist aktuell niemandem zugeordnet.")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Section {
                    if itemDetailVM.uiState.lastAssignees.isEmpty {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.primary.opacity(0.1))
                                
                                Image(systemName: "clock.arrow.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color.primary)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Keine bisherigen Zuweisungen")
                                    .foregroundStyle(.secondary)
                                Text("Hier siehst du später die letzten Mitarbeiter.")
                                    .font(.footnote)
                                    .foregroundStyle(.tertiary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    } else {
                        ForEach(itemDetailVM.uiState.lastAssignees, id: \.id) { employee in
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.primary.opacity(0.08))
                                    
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color.primary)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(employee.name)
                                        .fontWeight(.semibold)
                                    
                                    Text("01.01.25/12:00 Uhr - 01.02.25/13:43 Uhr")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                
//                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
            }
            .modifier(ListStyle(title: "Details"))
            .sheet(
                isPresented: $isAssignSheetPresented,
                onDismiss: {
                    itemDetailVM.load(assetId: asset.id)
                }
            ) {
                AssignAssetSheet(
                    itemIdString: asset.id.description(),
                    onClose: {
                        isAssignSheetPresented = false
                    }
                )
            }
            .sheet(
                isPresented: $isEditSheetIsPresented,
                onDismiss: {
                    itemDetailVM.load(assetId: asset.id)
                }
            ) {
                EditAssetSheet(asset: asset)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isEditSheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .onAppear {
                itemDetailVM.load(assetId: asset.id)
            }
            .onChange(of: itemDetailVM.uiState.operationSucceeded) { _, ok in
                if ok {
                    let updated = itemDetailVM.uiState.asset ?? asset
                    onSaved?(updated)
                    dismiss()
                }
            }
        }
    }
}

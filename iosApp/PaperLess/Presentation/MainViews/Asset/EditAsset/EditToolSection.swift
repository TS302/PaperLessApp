//
//  EditToolSection.swift
//  PaperLess
//
//  Created by Tom Salih on 22.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct EditToolSection: View {
    @ObservedViewModel var editAssetVM: EditAssetSheetViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Bezeichnung")
                .modifier(ListRowSubtitle())
            TextField(
                "Bezeichnung",
                text: Binding(
                    get: { editAssetVM.uiState.name },
                    set: { editAssetVM.setNameinState(newName: $0) }
                )
            )
            .modifier(ListRowTitle())
        }
        
        VStack(alignment: .leading) {
            Text("Marke")
                .modifier(ListRowSubtitle())
            TextField(
                "Marke",
                text: Binding(
                    get: { editAssetVM.uiState.brand ?? "" },
                    set: { editAssetVM.setBrandInState(newBrand: $0) }
                )
            )
            .modifier(ListRowTitle())
        }
        
        VStack(alignment: .leading) {
            Text("Seriennummer")
                .modifier(ListRowSubtitle())
            TextField(
                "Seriennummer",
                text: Binding(
                    get: { editAssetVM.uiState.serialNumber ?? "" },
                    set: { editAssetVM.setSerialNumberInState(newSerial: $0) }
                )
            )
            .modifier(ListRowTitle())
        }
        
        Picker("Status", selection: Binding(
            get: {
                (editAssetVM.uiState.status ?? TagStatus.available).caseName
            },
            set: { newCaseName in
                if let newStatus = TagStatus.all.first(where: { $0.caseName == newCaseName }) {
                    editAssetVM.setStatusInState(newStatus: newStatus)
                }
            }
        )) {
            ForEach(TagStatus.all, id: \.caseName) { status in
                HStack {
                    Text(status.displayName)
                }
                .tag(status.caseName)
            }
        }
    }
}

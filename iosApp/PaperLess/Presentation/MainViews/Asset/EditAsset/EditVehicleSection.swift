//
//  EditVehicleSection.swift
//  PaperLess
//
//  Created by Tom Salih on 22.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct EditVehicleSection: View {
    @ObservedViewModel var editAssetVM: EditAssetSheetViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Bezeichnung")
                .modifier(SubtitleModi())
            TextField(
                "Bezeichnung",
                text: Binding(
                    get: { editAssetVM.uiState.name },
                    set: { editAssetVM.setNameinState(newName: $0) }
                )
            )
            .modifier(TitleModi())
        }
        
        VStack(alignment: .leading) {
            Text("Marke")
                .modifier(SubtitleModi())
            TextField(
                "Marke",
                text: Binding(
                    get: { editAssetVM.uiState.brand ?? "" },
                    set: { editAssetVM.setBrandInState(newBrand: $0) }
                )
            )
            .modifier(TitleModi())
        }
        
        VStack(alignment: .leading) {
            Text("Kennzeichen")
                .modifier(SubtitleModi())
            TextField(
                "Kennzeichen",
                text: Binding(
                    get: { editAssetVM.uiState.plate ?? "" },
                    set: { editAssetVM.setPlateInState(newPlate: $0) }
                )
            )
            .modifier(TitleModi())
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

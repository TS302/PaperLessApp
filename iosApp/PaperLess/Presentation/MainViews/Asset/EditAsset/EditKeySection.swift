//
//  EditKeySection.swift
//  PaperLess
//
//  Created by Tom Salih on 22.11.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI

struct EditKeySection: View {
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


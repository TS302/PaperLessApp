//
//  HomeView.swift
//  PaperLess
//
//  Created by Tom Salih on 22.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI


struct HomeView: View {
    @ObservedViewModel var companyViewModel: CompanyViewModel
    
    init() {
        let companyViewModel = KoinStarter.shared.companyViewModel()
        self._companyViewModel = ObservedViewModel(wrappedValue: companyViewModel)
    }
    
    var body: some View {
        NavigationStack {
            let state = companyViewModel.uiState
            List(state.items, id: \.id.description) { item in
                Text("Count: \(state.items.count)")
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(item.targetType.name)
                        .font(.caption)
                }
            }
        }
        .task { companyViewModel.loadAllNfcTaggables() }
        .navigationTitle("Übersicht")
    }
}

#Preview {
    HomeView()
}

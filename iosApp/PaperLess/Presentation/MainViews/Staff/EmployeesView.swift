//
//  StaffView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI
import Shared
import KMPObservableViewModelSwiftUI
import KMPNativeCoroutinesAsync

struct EmployeesView: View {
    @ObservedViewModel var employeesVM: EmployeesViewModel
    @State private var uiState = EmployeesUiState.companion.empty()
    
    @State private var task: Task<Void, Never>? = nil
    
    init() {
        _employeesVM = ObservedViewModel(wrappedValue: KoinStarter.shared.employeesViewModel())
    }
    
    private var searchTextBinding: Binding<String> {
        Binding(
            get: { uiState.searchQueryText },
            set: { employeesVM.setSearchQueryForIos(queryText: $0) }
        )
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(uiState.items, id: \.id.description) { employee in
                        VStack(alignment: .leading) {
                            Text(employee.name).font(.headline)
                            Text(employee.email).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    HStack {
                        Text("Mitarbeiter")
                            .opacity(0.4)
                            .font(.callout)
                            .fontWeight(.black)
                            .foregroundStyle(Color.primary)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "slider.horizontal.2.square")
                                .padding(.trailing, 10)
                                .font(.system(size: 16))
                                .foregroundColor(Color.primary)
                                
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
            .modifier(ListStyle(title: ""))
            
        }
        
        .searchable(text: self.searchTextBinding, prompt: Text("Suchen"))
        .task {
            task?.cancel()
            task = Task {
                do {
                    for try await state in asyncSequence(for: employeesVM.uiStateFlow) {
                        await MainActor.run { uiState = state }
                    }
                } catch {
                    print("employees uiState flow error:", error)
                }
            }
        }
        .onDisappear { task?.cancel() }
        
    }
    
}

#Preview {
    EmployeesView()
}

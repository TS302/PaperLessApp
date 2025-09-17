//
//  KeyListViewModel.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation
import Combine

class KeyListViewModel: ObservableObject {
    
    @Published var showAddKey = false
    @Published var searchText: String = ""
    @Published var showEditKey = false
    @Published var selectedSegment = 0
    @Published var keys: [Key] = []
    @Published var key: Key
    @Published var favoriteKeys: [Key] = []
    @Published var filterOption: FilterOption = .all
    
    private let getKeys: LoadKeysUseCase
    private let getFavoriteKeys: LoadFavoriteKeyUseCase
//    private let addKey: AddKeyUseCase
    private let makeEmptyKey: MakeEmptyKeyUseCase
    private let deleteKey: DeleteKeyUseCase
    private let updateKey: UpdateKeyUseCase
    private let toggleFavoriteKey: ToggleFavoriteKeyUseCase
    
    init() {
        let repo = KeyRepository.shared
        self.getKeys = LoadKeysUseCase(repository: repo)
        self.getFavoriteKeys = LoadFavoriteKeyUseCase(repository: repo)
//        self.addKey = AddKeyUseCase(repository: repo)
        self.makeEmptyKey = MakeEmptyKeyUseCase(repository: repo)
        self.deleteKey = DeleteKeyUseCase(repository: repo)
        self.updateKey = UpdateKeyUseCase(repository: repo)
        self.toggleFavoriteKey = ToggleFavoriteKeyUseCase(repository: repo)
        
        self.key = makeEmptyKey.execute()
        self.updateKey.execute(key: key)
    }
    
    func loadKeys() {
        keys = getKeys.execute()
    }
    
    func loadFavoriteKeys() {
        favoriteKeys = getFavoriteKeys.execute()
    }
    
    func addKey(key: Key) {
//        addKey.execute(key: key)
    }
    
    func updateKey(key: Key) {
        updateKey.execute(key: key)
        loadKeys()
    }
    
    func deleteKey(id: UUID) {
        deleteKey.execute(id: id)
        loadKeys()
    }
    
    func togglefavoriteKey(key: Key) {
        toggleFavoriteKey.execute(key: key)
    }
    
    func emptyKey() {
        key = makeEmptyKey.execute()
    }
    
}

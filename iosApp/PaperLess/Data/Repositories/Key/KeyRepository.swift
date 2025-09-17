//
//  KeyRepository.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import SwiftUI

class KeyRepository: KeyRepositoryProtocol {
    
    static let shared = KeyRepository()
    private init() { }
    
    private var keys: [Key] = [
        Key(nfcTag: NFCTag(id: UUID(), tagID: "005", name: "KFZ-Schlüssel", status: DeviceStatus.loaned, icon: ObjectIcon.key.rawValue), keyNumber: "111-A11-2234", isFavorite: true),
        Key(nfcTag: NFCTag(id: UUID(), tagID: "006", name: "Briefkastenschlüssel", status: DeviceStatus.available, icon: ObjectIcon.key.rawValue), keyNumber: "AB1-BC11-2234", isFavorite: false)
    ]
    
    func getAllKeys() -> [Key] {
        return keys
    }
    
    func getAllFavoriteKeys() -> [Key] {
        return keys.filter { $0.isFavorite }
    }
    
    func addKey(key: Key) {
        keys.append(key)
    }
    
    func updateKey(key: Key) {
        if let index = keys.firstIndex(where: { $0.id == key.id }) {
            keys[index] = key
        }
    }
    
    func deleteKey(id: UUID) {
        keys.removeAll { $0.id == id }
    }
        
    func makeEmptyKey() -> Key {
        return Key(
            nfcTag: NFCTag(
                id: UUID(),
                tagID: "",
                name: "",
                status: DeviceStatus.available,
                icon: ObjectIcon.key.rawValue
            ),
            keyNumber: "", isFavorite: true
        )
    }
    
    func toggleFavoriteKey(key: Key) {
        key.isFavorite.toggle()
    }
}

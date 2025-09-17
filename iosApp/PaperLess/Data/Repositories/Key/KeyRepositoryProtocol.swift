//
//  KeyRepositoryProtocol.swift
//  PaperLess
//
//  Created by Tom Salih on 15.06.25.
//

import Foundation

protocol KeyRepositoryProtocol {
    func getAllKeys() -> [Key]
    func getAllFavoriteKeys() -> [Key]
    func addKey(key: Key)
    func makeEmptyKey() -> Key
    func deleteKey(id: UUID)
    func updateKey(key: Key)
    func toggleFavoriteKey(key: Key)
}

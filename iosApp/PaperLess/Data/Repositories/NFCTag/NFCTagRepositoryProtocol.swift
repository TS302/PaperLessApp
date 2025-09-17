//
//  NFCTagRepositoryProtocol.swift
//  PaperLess
//
//  Created by Tom Salih on 18.06.25.
//

import Foundation

protocol NFCTagRepositoryProtocol {
    func getAllNFCTags() -> [NFCTag]
    func loadFavorites()
    func toggleFavorite(nfcTag: NFCTag)
}

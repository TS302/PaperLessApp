//
//  Key.swift
//  PaperLess
//
//  Created by Tom Salih on 04.06.25.
//

import SwiftUI

class Key: NFCTagProtocol {
    let id: UUID = UUID()
    var nfcTag: NFCTag
    var isFavorite: Bool
    
    var keyNumber: String
    
    init(nfcTag: NFCTag,
         keyNumber: String,
         isFavorite: Bool
    ) {
        self.nfcTag = nfcTag
        self.keyNumber = keyNumber
        self.isFavorite = isFavorite
    }
}

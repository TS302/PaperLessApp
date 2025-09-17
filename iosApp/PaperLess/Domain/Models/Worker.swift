//
//  Worker.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI

class Worker: NFCTagProtocol {
    let id: UUID = UUID()
    var nfcTag: NFCTag
    var phoneNumber: String = ""
    var isAvailable: Bool = true
    var isWorking: Bool = false
    
    init (nfcTag: NFCTag,
          phoneNumber: String = "",
          isAvailable: Bool = true,
          isWorking: Bool = false
    ) {
        self.nfcTag = nfcTag
        self.phoneNumber = phoneNumber
        self.isAvailable = isAvailable
        self.isWorking = isWorking
    }
    
    
}

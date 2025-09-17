//
//  NFCTag.swift
//  PaperLess
//
//  Created by Tom Salih on 03.06.25.
//

import SwiftUI

struct NFCTag: Identifiable {
    var id: UUID = UUID()
    var tagID: String
    var name: String
    var status: DeviceStatus
    var icon: String
    
    
    init(id: UUID,
         tagID: String,
         name: String,
         status: DeviceStatus,
         icon: String,
    ) {
        self.id = id
        self.tagID = tagID
        self.name = name
        self.status = status
        self.icon = icon
    }
}

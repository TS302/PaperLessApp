//
//  KeyDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 04.06.25.
//

import SwiftUI

struct KeyDetailView: View {
    @Binding var key: Key
    
    var body: some View {
        Text(key.nfcTag.name)
    }
}

#Preview {
    KeyDetailView(key: .constant(Key(nfcTag: NFCTag(id: UUID(), tagID: "005", name: "KFZ-Schlüssel", status: DeviceStatus.available, icon: ObjectIcon.key.rawValue), keyNumber: "111-A11-2234", isFavorite: true)))
}

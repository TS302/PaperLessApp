//
//  StaffView.swift
//  PaperLess
//
//  Created by Tom Salih on 15.09.25.
//

import SwiftUI

struct StaffView: View {
    var workers: [Worker] = [
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: true, isWorking: false),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: false, isWorking: true),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: false, isWorking: true),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: true, isWorking: false),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: false, isWorking: false),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: true, isWorking: false),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: true, isWorking: false),
        Worker(nfcTag: NFCTag(id: UUID(), tagID: "1", name: "Tom Salih", status: DeviceStatus.available, icon: "person"), phoneNumber: "+9053123456789", isAvailable: true, isWorking: false),
        
    ]
    
    var body: some View {
        List {
            ForEach(workers) { worker in
                HStack {
                    Text(worker.nfcTag.name)
                    Spacer()
                    if worker.isAvailable {
                        Image(systemName: "progress.indicator")
                            .foregroundStyle(.green)
                    } else if worker.isWorking {
                        Image(systemName: "progress.indicator")
                            .foregroundStyle(.orange)
                    } else {
                        Image(systemName: "progress.indicator")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}



#Preview {
    StaffView()
}

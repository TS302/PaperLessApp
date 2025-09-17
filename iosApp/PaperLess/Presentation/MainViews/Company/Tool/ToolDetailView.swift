//
//  ToolDetailView.swift
//  PaperLess
//
//  Created by Tom Salih on 04.06.25.
//

import SwiftUI

struct ToolDetailView: View {
    @EnvironmentObject var nfcTagViewModel: CompanyViewModel
    @Binding var tool: Tool
    
    var body: some View {
        Text(tool.nfcTag.name)
    }
}

#Preview {
    ToolDetailView(tool: .constant(Tool(nfcTag: NFCTag(id: UUID(), tagID: "003", name: "Henry 2000", status: DeviceStatus.available, icon: ObjectIcon.tool.rawValue), brand: "Henry", toolType: ToolType.staubsauger, isFavorite: true)))
}

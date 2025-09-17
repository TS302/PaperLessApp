//
//  ToolListRow.swift
//  PaperLess
//
//  Created by Tom Salih on 28.06.25.
//

import SwiftUI

struct ToolListRow: View {
    @Binding var tool: Tool
    @EnvironmentObject var toolViewModel: ToolListViewModel
    @EnvironmentObject var nfcTagViewModel: CompanyViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading) {
                Text(tool.nfcTag.name)
                    .font(.headline)
                HStack {
                    
                    Image(systemName: "widget.small")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                    
                    Text(tool.nfcTag.tagID)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
            HStack {
                Image(systemName: tool.nfcTag.icon)
                Image(systemName: "ellipsis.rectangle.fill")
                    .foregroundStyle(Color(tool.nfcTag.status.color))
                Image(systemName: "star.fill")
                    .foregroundColor(tool.isFavorite ? .yellow : Color.primary.opacity(0.3))
            }
        }
        .modifier(ListStyle(title: ""))
        .scrollContentBackground(.hidden)
        .background(Color.appSecondary)
        .padding(.vertical, 8)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                tool.isFavorite.toggle()
                nfcTagViewModel.updateTool(tool: tool)
            } label: {
                Label(
                    tool.isFavorite ? "Unfavorite" : "Favorite",
                    systemImage: tool.isFavorite ? "star.slash" : "star.fill"
                )
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                nfcTagViewModel.deleteTool(id: tool.id)
            } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

#Preview {
    ToolListRow(tool: .constant(Tool(nfcTag: NFCTag(id: UUID(), tagID: "001", name: "Werkzeug", status: DeviceStatus.available, icon: ObjectIcon.tool.rawValue), brand: "", toolType: ToolType.fräse, isFavorite: true)))
}

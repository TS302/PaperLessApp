//
//  VehicleSegmentPicker.swift
//  PaperLess
//
//  Created by Tom Salih on 09.06.25.
//

import SwiftUI

struct SegmentPicker: View {
    @Binding var selectedSegment: Int
    var segmentCount: Int
    var label1: String
    var label2: String
    var label3: String?
    
    var body: some View {
        Picker("", selection: $selectedSegment) {
            if segmentCount == 2 {
                Text(label1).tag(0)
                Text(label2).tag(1)
            } else {
                Text(label1).tag(0)
                Text(label2).tag(1)
                Text(label3 ?? "Label 3").tag(2)
            }
            
        }
        .pickerStyle(.segmented)
        .listRowSeparator(.hidden)
        .padding(.bottom, 10)
        .listRowBackground(Color.secondary)
    }
}


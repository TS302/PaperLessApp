//
//  AssetUserDetailSection.swift
//  PaperLess
//
//  Created by Tom Salih on 24.11.25.
//

import SwiftUI

struct AssetUserDetailSection: View {
    let name: String
    let phoneNumber: String
    let email: String
    let id: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            CustomLabeledContent(label: "Name", content: name)
            CustomLabeledContent(label: "Telefonnummer", content: phoneNumber)
            CustomLabeledContent(label: "Email", content: email)
        }
    }
}

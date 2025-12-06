//
//  AssetUserDetailsSection.swift
//  PaperLess
//
//  Created by Tom Salih on 19.11.25.
//

import SwiftUI
import Shared

struct AssetUserDetailsSection: View {
    let assetUser: AssetUser
    
    var body: some View {
        
        
        let name = assetUser.name
        CustomLabeledContent(label: "Name", content: name)
        
        let phone = assetUser.phoneNumber
        if !phone.isEmpty {
            CustomLabeledContent(label: "Telefonnummer", content: phone)
        } else {
            Text("Keine Telefonnummer hinterlegt")
                .modifier(SubtitleModi())
        }
        
        let email = assetUser.email
        if !email.isEmpty {
            CustomLabeledContent(label: "Email", content: email)
        } else {
            Text("Keine E-Mail hinterlegt")
                .modifier(SubtitleModi())
        }
    }
}



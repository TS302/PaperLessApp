//
//  UserModel.swift
//  PaperLess
//
//  Created by Tom Salih on 28.03.25.
//

import Foundation

struct User: Identifiable {
    let id: UUID = UUID()
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var isLoggedIn: Bool
}


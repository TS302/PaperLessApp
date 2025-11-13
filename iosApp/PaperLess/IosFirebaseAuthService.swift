//
//  IosFirebaseAuthService.swift
//  PaperLess
//
//  Created by Tom Salih on 08.11.25.
//

import Foundation
import FirebaseAuth
import Shared 

final class IosFirebaseAuthService: NSObject, AuthService {
    func signInEmailPassword(emailAddress: String, plainPassword: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: emailAddress, password: plainPassword) { _, error in
            completionHandler(error)
        }
    }

    func registerEmailPassword(emailAddress: String, plainPassword: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: emailAddress, password: plainPassword) { _, error in
            completionHandler(error)
        }
    }

    func signOut(completionHandler: @escaping (Error?) -> Void) {
        do { try Auth.auth().signOut(); completionHandler(nil) }
        catch { completionHandler(error) }
    }

    func isUserLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
}

//
//  IOSAuthService.swift
//  PaperLess
//
//  Created by Tom Salih on 20.10.25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import Combine

final class IOSAuthService: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser
    @Published var errorMessage: String?
    @Published var isBusy: Bool = false
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
        
        self.user = Auth.auth().currentUser
    }
    
    @MainActor
    func signUp(email: String, password: String) async {
        
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            errorMessage = nil
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async {
        
        isBusy = true
        defer { isBusy = false }
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            errorMessage = nil
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

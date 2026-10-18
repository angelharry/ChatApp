//
//  AuthViewModel.swift
//  ChatApp
//
//  Created by Amitha George on 10/16/26.
//

import SwiftUI
import FirebaseAuth
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        // Keeps UI in sync with login state, including after app relaunch
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }

    func signUp(email: String, password: String) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { errorMessage = error.localizedDescription }
    }

    func resetPassword(email: String) async {
        try? await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

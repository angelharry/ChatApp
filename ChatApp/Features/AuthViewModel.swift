//
//  AuthViewModel.swift
//  ChatApp
//
//  Created by Anju on 10/16/26.
//

import SwiftUI
import FirebaseAuth
import Combine
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var verificationID: String?
    private var handle: AuthStateDidChangeListenerHandle?
        
    @Published private(set) var isLoggedIn = Auth.auth().currentUser != nil
    
    init() {
            handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                self?.user = user
                
                let loggedIn = user != nil
                Task { @MainActor [weak self] in
                    self?.isLoggedIn = loggedIn
                    if loggedIn { await self?.saveUser() }
                }
            }
            if isLoggedIn { Task { await saveUser() } }
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
    
    func sendCode(to phoneNumber: String) async {
        do {
            verificationID = try await PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        } catch { errorMessage = error.localizedDescription }
    }
    
    func verifyCode(_ code: String) async {
        guard let verificationID else { return }
        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: code)
        do { try await Auth.auth().signIn(with: credential) }
        catch { errorMessage = error.localizedDescription }
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { errorMessage = error.localizedDescription }
    }

    func resetPassword(email: String) async {
        try? await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    private func saveUser() async {
            guard let user = Auth.auth().currentUser else { return }
            do {
                try await Firestore.firestore().collection("users").document(user.uid).setData([
                    "name": user.displayName ?? user.email ?? "Unknown",
                    "email": user.email ?? ""
                ], merge: true)
            } catch {
                print("saveUser failed: \(error)")
            }
        }
}

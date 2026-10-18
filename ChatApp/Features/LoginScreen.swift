//
//  LoginScreen.swift
//  ChatApp
//
//  Created by Anju on 10/16/26.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @StateObject private var auth = AuthViewModel()
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        if let user = auth.user {
            VStack(spacing: 16) {
                Text("Welcome, \(user.email ?? "")")
                Button("Sign Out") { auth.signOut() }
            }
        } else {
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)

                Button("Sign In") { Task { await auth.signIn(email: email, password: password) } }
                Button("Create Account") { Task { await auth.signUp(email: email, password: password) } }

                if let error = auth.errorMessage {
                    Text(error).foregroundStyle(.red).font(.caption)
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding()
        }
    }
}

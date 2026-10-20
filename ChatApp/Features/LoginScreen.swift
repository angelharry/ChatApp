//
//  LoginScreen.swift
//  ChatApp
//
//  Created by Anju on 10/16/26.
//

import SwiftUI
import FirebaseAuth

struct LoginScreen: View {
    @ObservedObject var auth: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = true //false for Sign-in
    @State private var isLoading = false
    
    private var canSubmit : Bool {
        !email.isEmpty && password.count >= 6 && !isLoading
        //firebase require passwords of atleast 6 characters
    }

    var body: some View {
            VStack(spacing: 0) {
                Text("App Name")
                    .font(.title2.bold())
                    .padding(.top, 48)
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    VStack(spacing: 6) {
                        Text(isSignUp ? "Create an account" : "Login to your account")
                            .font(.headline)
                        
                        Text(isSignUp ? "Enter your email to sign up for this app" : "Enter your email to sign in for this app")
                            .font(.subheadline)
                    }
                    
                    TextField("email@domain.com", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)

                    if let error = auth.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button(action: submit) {
                        Group {
                            if isLoading {
                                ProgressView().tint(Color(.systemBackground))
                            } else {
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .fontWeight(.medium)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .foregroundStyle(Color(.systemBackground))
                            .background(Color.primary.opacity(canSubmit ? 1 : 0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!canSubmit)
                    
                    HStack(spacing: 4) {
                        Text(isSignUp ? "If you already have an account, " : "If you dont have an account, ")
                       
                        Button(isSignUp ? "SignIn here" : "SignUp here") {
                            auth.errorMessage = nil
                            isSignUp.toggle()
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                Spacer()
                
                Text("By clicking continue, you agree to our [Terms of Service] and [Privacy Policy]")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .tint(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
    }
    
    private func submit() {
        isLoading = true
        auth.errorMessage = nil
        Task {
            if isSignUp {
                await auth.signUp(email: email, password: password)
            } else {
                await auth.signIn(email: email, password: password)
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginScreen(auth: AuthViewModel())
}

//
//  ContentView.swift
//  ChatApp
//
//  Created by Anju on 10/9/26.
//

import SwiftUI
import SwiftData
import FirebaseAuth

//intilial flickering to login screen before message screen flow? check?
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
//    @State private var userName: String
    
    @StateObject private var auth = AuthViewModel()
    
    var body: some View {
        if let _ = auth.user {//if auth.isLoggedIn {
            VStack(spacing: 16) {
                ThreadScreenView()
                Spacer()
                Button("Sign Out") { auth.signOut()} //hide on message screen
            }
        } else {
            LoginScreen(auth: auth)
        }
    }
}

#Preview {
    ContentView()
}

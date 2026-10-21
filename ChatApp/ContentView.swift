//
//  ContentView.swift
//  ChatApp
//
//  Created by Anju on 10/9/26.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
//    @State private var userName: String
    
    @StateObject private var auth = AuthViewModel()
    
    var body: some View {
        if let _ = auth.user {//if auth.isLoggedIn {
            VStack(spacing: 16) {
                Button("Sign Out") { auth.signOut()}
                
//                TextField("Search UserId", text: $userName)
                ThreadScreenView()

               // MessageScreenView(otherUserId: "MQAk2OBswzgEhFiY0b4Osa0sITH3_PATWt8KjMvMK223slonZnQgORbO2")
            }
        } else {
            LoginScreen(auth: auth)
        }
    }
}

#Preview {
    ContentView()
}

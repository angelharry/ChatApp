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
//make complete fine working includes:
//1) Complete all done to clean MVVM files and folders
//2) correct email/phone login to app - XCTested
//3) login & sign up flow
//4) better UI for chat list and chat view, update file names
//5) proper commenting
//6) medium documentation
//5) general custome files - string, color, theme
//7) fast-responsive, optimisation, SOLID, DI.
//8)test case - skip to next phase

//phase 2 - 2 week
//search contact/unique ID/Username -> RD , AI search (RD only)
//do we need persisten storage - coredata, swiftdata? RD
//offline support, working test
//APNs - background work.
//security - end to end encyption chat
//chat module integration to another proj
//modular architetcture

//phase 3
//emoji, image, video, document, audio uplaod, url share - quality compress - RD
//audio/video call integration
//google & apple sign in

//appointments app
//watch OS appointments - notifications.



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


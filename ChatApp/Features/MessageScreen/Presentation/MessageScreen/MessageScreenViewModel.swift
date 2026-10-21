//
//  MessageScreenViewModel.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor //add @Observable macro
//ChatViewModel
final class MessageScreenViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String?
    
    let myId: String
    private let otherId: String
    private let chatId: String
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init(otherUserId: String) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        self.myId = uid
        self.otherId = otherUserId
        self.chatId = [uid, otherUserId].sorted().joined(separator: "_")
    }
    
    private var chatRef: DocumentReference {
        db.collection("chats").document(chatId)
    }
    
    func startListening() {
           listener = db.collection("chats").document(chatId)
               .collection("messages")
               .order(by: "timestamp")
               .addSnapshotListener { [weak self] snapshot, error in
                   guard let docs = snapshot?.documents else { return }
                   self?.messages = docs.compactMap { try? $0.data(as: Message.self) }
               }
       }
    
//    func startListening() {
//        guard listener == nil else{return}
//        
//        listener = chatRef.collection("messages")
//            .order(by: "timestamp", descending: false)
//            .limit(toLast: 100)
//            .addSnapshotListener { [weak self] snapshot, error in
//                let msgs = snapshot?.documents.compactMap { try? $0.data(as: Message.self)} ?? []
//                let errText = error?.localizedDescription
//                
//                Task { @MainActor [weak self] in
//                    guard let self else {return}
//                    if let errText {
//                        self.errorMessage = errText
//                        return
//                    }
//                    self.messages = msgs
//                }
//            }
//    }
    
    func stopListening() {
            listener?.remove()
        }
    
//    func stopListening() {
//        listener?.remove()
//        listener = nil
//    }
    
    func send(_ text: String) {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }

            let chatRef = db.collection("chats").document(chatId)
            let message = Message(senderId: myId, text: trimmed)

            // 1. Make sure the chat doc exists / update preview
            chatRef.setData([
                "participants": [myId, otherId],
                "lastMessage": trimmed,
                "lastSenderId" : myId,
                "lastTimestamp": FieldValue.serverTimestamp()
            ], merge: true)

            // 2. Add the message
            do {
                try chatRef.collection("messages").addDocument(from: message)
            } catch {
                print("Send failed: \(error)")
            }
        }
    
//    func send(_ text: String) {
//        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty, !myId.isEmpty else {return}
//        
//        let messageRef = chatRef.collection("messages").document()
//        let message = Message(senderId: myId, text: trimmed)
//        
//        let batch = db.batch()
//        do {
//            try batch.setData(from: message, forDocument: messageRef)
//        } catch {
//            errorMessage = error.localizedDescription
//            return
//        }
//        
//        batch.setData([
//            "participants" : [myId, otherId],
//            "lastMessage" : trimmed,
//            "lastSenderId" : myId,
//            "lastTimestamp" : FieldValue.serverTimestamp()
//        ], forDocument: chatRef, merge: true)
//        
//        batch.commit { [weak self] error in
//            let errText = error?.localizedDescription
//            Task { @MainActor [weak self] in
//                if let errText {
//                    self?.errorMessage = errText
//                }
//            }
//        }
//    }
}


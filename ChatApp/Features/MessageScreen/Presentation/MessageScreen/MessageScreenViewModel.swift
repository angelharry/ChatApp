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
        guard listener == nil else{return}
        
        listener = chatRef.collection("messages")
//            .order(by: "timestamp", descending: false)
//            .limit(toLast: 100)
            .addSnapshotListener { [weak self] snapshot, error in
                let msgs = snapshot?.documents.compactMap { try? $0.data(as: Message.self)} ?? []
                let errText = error?.localizedDescription
                
                Task { @MainActor [weak self] in
                    guard let self else {return}
                    if let errText {
                        self.errorMessage = errText
                        return
                    }
                    self.messages = msgs
                }
            }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !myId.isEmpty else {return}
        
        let messageRef = chatRef.collection("messages").document()
        let message = Message(senderId: myId, text: trimmed)
        
        let batch = db.batch()
        do {
            try batch.setData(from: message, forDocument: messageRef)
        } catch {
            errorMessage = error.localizedDescription
            return
        }
        
        batch.setData([
            "participants" : [myId, otherId],
            "lastMessage" : trimmed,
            "lastSenderId" : myId,
            "lastTimestamp" : FieldValue.serverTimestamp()
        ], forDocument: chatRef, merge: true)
        
        batch.commit { [weak self] error in
            let errText = error?.localizedDescription
            Task { @MainActor [weak self] in
                if let errText {
                    self?.errorMessage = errText
                }
            }
        }
    }
    
//    func fetchMessages() async {
//        do {
//            let snapshot = try await chatRef.collection("messages")
////                .order(by: "timestamp")
////                .limit(toLast: 100)
//                .getDocuments()
//
//            print("chatId: \(chatId), documents found: \(snapshot.documents.count)")
//
//            // try (not try?) so decoding errors are visible
//            do {
//                messages = try snapshot.documents.map { try $0.data(as: Message.self) }
//            } catch {
//                print("decoding eror : \(error)")
//                errorMessage = error.localizedDescription
//            }
//        } catch {
//            print("Fetch failed: \(error)")
//            errorMessage = error.localizedDescription
//        }
//    }
}


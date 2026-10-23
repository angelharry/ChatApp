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
    //    @Published var messages: [Message] = []
    @Published private(set) var messages: [Message] = []
    @Published var draft = ""
    @Published var errorMessage: String?
    
    let myId: String
    private let otherUserId: String
    //    private let chatId: String
    private let observeMessages: ObserveMessageUseCase
    private let sendMessage: SendMessageUseCase
    
    //    private let db = Firestore.firestore()
    //    private var listener: ListenerRegistration?
    
    //    init(otherUserId: String) {
    //        let uid = Auth.auth().currentUser?.uid ?? ""
    //        self.myId = uid
    //        self.otherId = otherUserId
    //        self.chatId = [uid, otherUserId].sorted().joined(separator: "_")
    //    }
    
    init(myId: String, otherUserId: String, observeMessage: ObserveMessageUseCase, sendMessage: SendMessageUseCase) {
        self.myId = myId
        self.otherUserId = otherUserId
        self.observeMessages = observeMessage
        self.sendMessage = sendMessage
    }
    
    //    private var chatRef: DocumentReference {
    //        db.collection("chats").document(chatId)
    //    }
    
    var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isMine(_ message:Message) -> Bool {
        message.senderId == myId
    }
    
    func startObserving() async {
        do {
            for try await updated in observeMessages.execute(otherUserId: otherUserId){
                messages = updated
            }
        } catch is CancellationError {
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func sendTapped() {
        let text = draft
        draft = ""
        Task {
            do {
                try await sendMessage.execute(text: text, to: otherUserId)
            } catch {
                if draft.isEmpty { draft = text}
                errorMessage = error.localizedDescription
            }
        }
    }
}
    
//    func startListening() {
//        listener = db.collection("chats").document(chatId)
//            .collection("messages")
//            .order(by: "timestamp")
//            .addSnapshotListener { [weak self] snapshot, error in
//                guard let docs = snapshot?.documents else { return }
//                self?.messages = docs.compactMap { try? $0.data(as: Message.self) }
//            }
//    }
//    
//    
//    func stopListening() {
//        listener?.remove()
//    }
//    
    
//    func send(_ text: String) {
//        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !trimmed.isEmpty else { return }
//        
//        let chatRef = db.collection("chats").document(chatId)
//        let message = Message(senderId: myId, text: trimmed)
//        
//        // 1. Make sure the chat doc exists / update preview
//        chatRef.setData([
//            "participants": [myId, otherId],
//            "lastMessage": trimmed,
//            "lastSenderId" : myId,
//            "lastTimestamp": FieldValue.serverTimestamp()
//        ], merge: true)
//        
//        // 2. Add the message
//        do {
//            try chatRef.collection("messages").addDocument(from: message)
//        } catch {
//            print("Send failed: \(error)")
//        }
//    }
//}

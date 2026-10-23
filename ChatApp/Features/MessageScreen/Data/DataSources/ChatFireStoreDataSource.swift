//
//  ChatFireStoreDataSource.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation
import FirebaseFirestore

final class ChatFireStoreDataSource {
    private let db: Firestore
    
    init(db: Firestore = .firestore()) {
        self.db = db
    }
    
    func observeMessages(chatId: String) -> AsyncThrowingStream<[MessageDTO], Error> {
        AsyncThrowingStream { continuation in
            let listener = db.collection("chats").document(chatId)
                .collection("messages")
                .order(by: "timestamp")
                .addSnapshotListener { [weak self] snapshot, error in
                    if let error {
                        continuation.finish(throwing: error)
                        return
                    }
                    guard let docs = snapshot?.documents else { return }
                    continuation.yield(docs.compactMap {
                        try? $0.data(as: MessageDTO.self)
                    })
                }
            continuation.onTermination = {_ in listener.remove() }
        }
    }
    
    func send(_ dto: MessageDTO, chatId: String, participants: [String]) async throws {
        let chatRef = db.collection("chats").document(chatId)
        let messageRef = chatRef.collection("messages").document()
        
        let batch = db.batch()
        batch.setData([
            "participants": participants,
            "lastMessage": dto.text,
            "lastSenderId" : dto.senderId,
            "lastTimestamp": FieldValue.serverTimestamp()
        ], forDocument: chatRef, merge: true)
        try batch.setData(from: dto, forDocument: messageRef)
        try await batch.commit()
    }
}

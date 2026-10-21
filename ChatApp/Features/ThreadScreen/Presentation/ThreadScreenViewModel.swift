//
//  ThreadScreenViewModel.swift
//  ChatApp
//
//  Created by Anju on 10/20/26.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor //ChatListViewModel
final class ThreadScreenViewModel: ObservableObject {
    
    @Published private(set) var rows: [ChatRow] = []
    @Published private(set) var names: [String:String] = [:]
    @Published var errorMessage: String?
    
    let myId: String = Auth.auth().currentUser?.uid ?? ""
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func startListening() {
        guard listener == nil, !myId.isEmpty else {return}
        let myId = self.myId
        
        listener = db.collection("chats")
            .whereField("participants", arrayContains: myId)
            .order(by: "lastTimestamp", descending:  true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error {
                    print("Chat list error : \(error)")
                    let text = error.localizedDescription
                    Task { @MainActor [weak self] in self?.errorMessage = text}
                    return
                }
                
                let rows: [ChatRow] = (snapshot?.documents ?? []).compactMap { doc in
                    let data = doc.data(with: .estimate)
                    let participants = data["participants"] as? [String] ?? []
                    guard let other = participants.first(where: {$0 != myId}) else {return nil}
                    
                    return ChatRow(
                        id: doc.documentID,
                        otherUserId: other,
                        lastMessage: data["lastMessage"] as? String ?? "",
                        lastSenderId: data["lastSenderId"] as? String ?? "",
                        date: (data["lastTimestamp"] as? Timestamp)?.dateValue()
                    )
                }
                Task { @MainActor [weak self] in
                    guard let self else {return}
                    self.rows = rows
                    await self.loadNames(for: rows.map(\.otherUserId))
                }
            }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    func name(for uid: String) -> String { names[uid] ?? "" }
    
    private func loadNames(for ids: [String]) async {
        for id in Set(ids) where names[id] == nil {
            do {
                let doc = try await db.collection("users").document(id).getDocument()
                names[id] = doc.data()?["name"] as? String ?? "I am unknown"
            } catch {
                print("Name load failed for \(id) : \(error)")
            }
        }
    }
}

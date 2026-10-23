//
//  ThreadScreenView.swift
//  ChatApp
//
//  Created by Anju on 10/20/26.
//

import SwiftUI
//ChatListView
struct ThreadScreenView: View {

    @StateObject private var vm = ThreadScreenViewModel()
    let chatFeature = ChatFeature(session: FirebaseSessionProvider())


    var body: some View {
        NavigationStack {
            List(vm.rows) { row in
                NavigationLink() {
                    chatFeature.makeView(otherUserId: row.otherUserId)
                } label: {
                    ChatRowView(
                        name: vm.name(for: row.otherUserId),
                        preview: row.lastSenderId == vm.myId
                            ? "You: \(row.lastMessage)" : row.lastMessage,
                        date: row.date
                    )
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .overlay {
                if vm.rows.isEmpty {
                    ContentUnavailableView(
                        "No chats yet",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Start a conversation from the Users tab.")
                    )
                }
            }
            .onAppear { vm.startListening() }
            .onDisappear { vm.stopListening() }
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}

struct ChatRowView: View {
    let name: String
    let preview: String
    let date: Date?

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 48, height: 48)
                .overlay(Text(name.prefix(1).uppercased()).font(.headline))

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(name).font(.headline)
                    Spacer()
                    if let date {
                        Text(date, style: .time)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

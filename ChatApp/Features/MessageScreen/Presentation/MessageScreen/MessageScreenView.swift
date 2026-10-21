//
//  MessageScreenView.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import SwiftUI

//rename to ChatView
struct MessageScreenView: View {

    @StateObject private var vm: MessageScreenViewModel
    @State private var draft = ""
    @FocusState private var isInputFocused: Bool
    
    init(otherUserId: String) {
        _vm = StateObject(wrappedValue: MessageScreenViewModel(otherUserId: otherUserId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            messagesList
            Divider()
            inputBar
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
       // .task { await vm.fetchMessages() }
        .onAppear { vm.startListening() } //use more efiicent way
        .onDisappear { vm.stopListening() }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("Ok") {vm.errorMessage = nil}
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
        
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(vm.messages) { msg in
                        MessageBubble(message: msg, isMine: msg.senderId == vm.myId)
                            .id(msg.id)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: vm.messages.last?.id) { _, _ in
                if let last = vm.messages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("Message...", text: $draft, axis: .vertical)
               .lineLimit(1...5)
               .focused($isInputFocused)
               .padding(10)
               .background(Color(.systemGray6))
               .clipShape(RoundedRectangle(cornerRadius: 20))

           Button {
               vm.send(draft)
               draft = ""
           } label: {
                Image(systemName: "arrow.up.circle.fill")
                   .font(.system(size: 32))
           }
           .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageBubble: View {
    let message: Message
    let isMine: Bool
    
    var body: some View{
        HStack{
            if isMine {
                Spacer(minLength: 50)
            }
            VStack(alignment: isMine ? .trailing : .leading, spacing: 2) {
                Text(message.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isMine ? Color.blue : Color(.systemGray5))
                    .foregroundStyle(isMine ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Text(message.date, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            if !isMine {
                Spacer(minLength: 50)
            }
        }
    }
}

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
//    @State private var draft = ""
//    @FocusState private var isInputFocused: Bool
    
//    init(otherUserId: String) {
//        _vm = StateObject(wrappedValue: MessageScreenViewModel(otherUserId: otherUserId))
//    }
    
    init(viewModel: @autoclosure @escaping () -> MessageScreenViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            messagesList
            Divider()
            InputBar(text: $vm.draft, canSend: vm.canSend, onSend: vm.sendTapped)
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear { vm.startListening() } //use more efiicent way
//        .onDisappear { vm.stopListening() }
        .task {
            await vm.startObserving()
        }
        .alert("Error", isPresented: errorBinding) {
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
    
    private var errorBinding: Binding<Bool> {
           Binding(
               get: { vm.errorMessage != nil },
               set: { if !$0 { vm.errorMessage = nil } }
           )
       }
//    
//    private var inputBar: some View {
//        HStack(alignment: .bottom, spacing: 8) {
//            TextField("Message...", text: $draft, axis: .vertical)
//               .lineLimit(1...5)
//               .focused($isInputFocused)
//               .padding(10)
//               .background(Color(.systemGray6))
//               .clipShape(RoundedRectangle(cornerRadius: 20))
//
//           Button {
//               vm.send(draft)
//               draft = ""
//           } label: {
//                Image(systemName: "arrow.up.circle.fill")
//                   .font(.system(size: 32))
//           }
//           .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//    }
}



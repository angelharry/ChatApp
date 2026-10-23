////
////  MessageScreenSendMessageView.swift
////  ChatApp
////
////  Created by Anju on 10/11/26.
////
//
import SwiftUI
//
//struct MessageScreenSendMessageView: View {
//    @State private var draft = ""
//    @FocusState private var isInputFocused: Bool
//    @StateObject var vm: MessageScreenViewModel
//
//    var onMicTap: () -> Void = {}
//    var onPhotoTap: () -> Void = {}
//    
//    var body: some View {
//        HStack(alignment: .bottom, spacing: 16) {
//            TextField("Message...", text: $draft, axis: .vertical)
//                .lineLimit(1...5)
//                .focused($isInputFocused)
//            
//            Button {
//                vm.send(draft)
//                draft = ""
//            } label: {
//                 Image(systemName: "arrow.up.circle.fill")
//                    .font(.system(size: 32))
//            }
//            .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
//            
////            Button(action: onMicTap) {
////                Image(systemName: "mic")
////            }
////            Button(action: onPhotoTap) {
////                Image(systemName: "photo")
////            }
//        }
//        .font(.title2)
//        .foregroundStyle(.secondary)
//        .padding(.horizontal, 16)
//        .padding(.vertical, 12)
//        .background(.background, in: .rect(cornerRadius: 12))
//        .overlay{
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(.gray.opacity(0.3), lineWidth: 1)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    //how can i pass vm from a view to another view
//    @Previewable @State var message = ""
//    MessageScreenSendMessageView(vm: $message, onMicTap: { print("Start recording") }, onPhotoTap: { print("Open photo library") })
//}


struct InputBar:  View {
    @Binding var text: String
    let canSend: Bool
    let onSend: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("Message...", text: $text, axis: .vertical)
                .lineLimit(1...5)
                .focused($isFocused)
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
            }
            .disabled(!canSend)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

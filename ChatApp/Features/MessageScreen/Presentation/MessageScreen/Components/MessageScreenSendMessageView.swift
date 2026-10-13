//
//  MessageScreenSendMessageView.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import SwiftUI

struct MessageScreenSendMessageView: View {
    @Binding var message: String
    var onMicTap: () -> Void = {}
    var onPhotoTap: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 16) {
            TextField("Message...", text: $message)

            Button(action: onMicTap) {
                Image(systemName: "mic")
            }
            Button(action: onPhotoTap) {
                Image(systemName: "photo")
            }
        }
        .font(.title2)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.background, in: .rect(cornerRadius: 12))
        .overlay{
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.3), lineWidth: 1)
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var message = ""
    MessageScreenSendMessageView(message: $message, onMicTap: { print("Start recording") }, onPhotoTap: { print("Open photo library") })
}

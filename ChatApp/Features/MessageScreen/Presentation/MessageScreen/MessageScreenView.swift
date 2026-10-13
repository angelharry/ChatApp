//
//  MessageScreenView.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import SwiftUI

struct MessageScreenView: View {
    @State var message: String
    
    var body: some View {
        VStack {
            MessageScreenTopHeaderView(
                avatar: "Profile Image",
                name: "Username here",
                status: "Active 00m ago"
            )
            
            MessageView()
            Spacer()
            
            MessageScreenSendMessageView(message: $message, onMicTap: { print("Start recording") }, onPhotoTap: { print("Open photo library") })
        }
    }
}

#Preview {
    MessageScreenView(message: "")
}

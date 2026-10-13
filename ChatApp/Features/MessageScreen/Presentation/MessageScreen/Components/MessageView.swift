//
//  MessageView.swift
//  ChatApp
//
//  Created by Anju on 10/12/26.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        VStack {
            MessageScreenMessageDateTimeView(dateTimeOfMessage : "Nov 30, 2023, 9:41 AM")
            TextMessageView(
                text: "That’s all it takes to build a custom view. Simple and easy! I've covered just what you need to know.",
                time :"7:15 am"
            )
        }
        .padding()
    }
}

#Preview {
    MessageView()
}

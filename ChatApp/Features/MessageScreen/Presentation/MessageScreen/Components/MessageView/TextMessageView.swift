//
//  TextMessageView.swift
//  ChatApp
//
//  Created by Anju on 10/12/26.
//

import SwiftUI

struct TextMessageView: View {
    let text: String
    let time: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(text)
                .padding(.bottom, 12)
            
            Text(time)
                .font(.caption)
                .opacity(0.5)
        }
        .padding()
        .foregroundStyle(.white)
        .background(Color.black)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 30, bottomTrailingRadius: 5, topTrailingRadius: 30))
    }
}

#Preview {
    TextMessageView(
        text: "That’s all it takes to build a custom view. Simple and easy! I've covered just what you need to know.what you need to know.",
        time :"7:15 am"
    )
    .padding()
}

////
////  TextMessageView.swift
////  ChatApp
////
////  Created by Anju on 10/12/26.
////
//
//import SwiftUI
//
//struct TextMessageView: View {
//    let message: Message
//    let isMine: Bool
//    
//    let text: String
//    let time: String
//    
//    var body: some View {
//        HStack {
//            if isMine {
//                Spacer(minLength: 50)
//            }
//            VStack(alignment: isMine ? .trailing : .leading, spacing: 2) {
//                Text(message.text)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 8)
//                    .background(isMine ? Color.blue : Color(.systemGray5))
//                    .foregroundStyle(isMine ? .white : .primary)
//                    .clipShape(RoundedRectangle(cornerRadius: 18))
//                
//                Text(message.date, style: .time)
//                    .font(.caption2)
//                    .foregroundStyle(.secondary)
////                    .opacity(0.5)
//            }
//            if !isMine {
//                Spacer(minLength: 50)
//            }
//        }
////        ZStack(alignment: .bottomTrailing) {
////            Text(text)
////                .padding(.bottom, 12)
////            
////            Text(time)
////                .font(.caption)
////                .opacity(0.5)
////        }
////        .padding()
////        .foregroundStyle(.white)
////        .background(Color.black)
////        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 30, bottomTrailingRadius: 5, topTrailingRadius: 30))
//    }
//}
//
//#Preview {
//    TextMessageView(
//        text: "That’s all it takes to build a custom view. Simple and easy! I've covered just what you need to know.what you need to know.",
//        time :"7:15 am"
//    )
//    .padding()
//}

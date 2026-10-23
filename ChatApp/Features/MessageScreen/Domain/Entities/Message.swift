//
//  Message.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import Foundation
//import SwiftUI
//import FirebaseFirestore

//struct Message: Identifiable, Codable, Equatable {
//    @DocumentID var id: String?
//    let senderId: String
//    let text: String
//    @ServerTimestamp var timestamp: Timestamp?
//
//    var date: Date { timestamp?.dateValue() ?? Date() }
//}

struct Message: Identifiable, Equatable {
    let id: String
    let senderId: String
    let text: String
    let date: Date
}

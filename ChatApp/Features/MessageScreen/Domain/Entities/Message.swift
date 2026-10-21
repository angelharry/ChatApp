//
//  Message.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import Foundation
import SwiftUI
import FirebaseFirestore

//struct Message: Identifiable, Codable, Equatable, Sendable { ... }
struct Message: Identifiable, Codable, Equatable {
    var id: String?
    let senderId: String
    let text: String
    @ServerTimestamp var timeStamp: Timestamp?
    
    var date: Date {timeStamp?.dateValue() ?? Date()}
}

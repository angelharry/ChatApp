//
//  MessageDTO.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation
import FirebaseFirestore

struct MessageDTO: Codable {
    @DocumentID var id: String?
    let senderId: String
    let text: String
    @ServerTimestamp var timestamp: Timestamp?
}

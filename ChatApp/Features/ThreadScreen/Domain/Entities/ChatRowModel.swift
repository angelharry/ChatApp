//
//  ChatRowModel.swift
//  ChatApp
//
//  Created by Anju on 10/21/26.
//

import Foundation

struct ChatRow: Identifiable, Sendable {
    let id: String              // chatId
    let otherUserId: String
    let lastMessage: String
    let lastSenderId: String
    let date: Date?
}

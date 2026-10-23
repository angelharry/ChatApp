//
//  MessageMapper.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation
import FirebaseCore

enum MessageMapper {
    static func toDomain(_ dto: MessageDTO) -> Message? {
        guard let id = dto.id else { return nil }
        return Message(
            id: id,
            senderId: dto.senderId,
            text: dto.text,
            date: dto.timestamp?.dateValue() ?? Date()
        )
    }
}

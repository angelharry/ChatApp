//
//  SendMessageUseCase.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import Foundation

protocol SendMessageUseCase {
    func execute(text: String, to otherUserId: String) async throws
}

struct DefaultSendMessageUseCase: SendMessageUseCase {
    let repository: MessageScreenRepository
    
    func execute(text: String, to otherUserId: String) async throws {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        try await repository.send(text: trimmed, to: otherUserId)
    }
}

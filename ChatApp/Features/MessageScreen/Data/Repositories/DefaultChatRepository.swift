//
//  DefaultChatRepository.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation

final class DefaultChatRepository: MessageScreenRepository {
    private let dataSource: ChatFireStoreDataSource
    private let session: SessionProvider
    
    init(dataSource: ChatFireStoreDataSource, session: SessionProvider) {
        self.dataSource = dataSource
        self.session = session
    }
    
    func observeMessages(with otherUserId: String) -> AsyncThrowingStream<[Message], any Error> {
        AsyncThrowingStream { continuation in
            guard let myId = session.currentUserId else {
                continuation.finish(throwing: ChatError.notAuthenticated)
                return
            }
            let chatId = Self.chatId(myId, otherUserId)
            let task = Task {
                do {
                    for try await dtos in dataSource.observeMessages(chatId: chatId) {
                        continuation.yield(dtos.compactMap(MessageMapper.toDomain))
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = {_ in task.cancel()}
        }
    }
    
    func send(text: String, to otherUserId: String) async throws {
        guard let myId = session.currentUserId else {
            throw ChatError.notAuthenticated
        }
        let dto = MessageDTO(id: nil, senderId: myId, text: text, timestamp: nil)
        try await dataSource.send(dto, chatId: Self.chatId(myId, otherUserId), participants: [myId, otherUserId])
    }
    
    private static func chatId(_ a: String, _ b:String) -> String {
        [a,b].sorted().joined(separator: "_")
    }
}

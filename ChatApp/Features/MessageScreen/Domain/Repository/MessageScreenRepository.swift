//
//  MessageScreenRepository.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import Foundation

//ChatRepository.swift
protocol MessageScreenRepository {
    func observeMessages(with otherUserId: String) -> AsyncThrowingStream<[Message], Error>
    func send(text: String, to otherUserId: String) async throws
}

enum ChatError: LocalizedError {
    case notAuthenticated
    var errorDescription: String? {"Sign in to Chat"}
}

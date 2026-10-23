//
//  FetchMessagesUseCase.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import Foundation
//ObserveMessagesUseCase.swift
protocol ObserveMessageUseCase {
    func execute(otherUserId: String) -> AsyncThrowingStream<[Message], Error>
}

struct DefaultObserveMessageUseCase: ObserveMessageUseCase {
    let repository: MessageScreenRepository
    
    func execute(otherUserId: String) -> AsyncThrowingStream<[Message], Error> {
        repository.observeMessages(with: otherUserId)
    }
}

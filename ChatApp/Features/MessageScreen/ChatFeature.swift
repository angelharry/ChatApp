//
//  ChatFeature.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation
import SwiftUI

final class ChatFeature {
    private let session: SessionProvider
    private let repository: MessageScreenRepository
    
    init(session: SessionProvider) {
        self.session = session
        self.repository = DefaultChatRepository(dataSource: ChatFireStoreDataSource(), session: session)
    }
    
    @MainActor
    func makeView(otherUserId: String) -> some View {
        MessageScreenView(viewModel: MessageScreenViewModel(
            myId: self.session.currentUserId ?? "",
            otherUserId: otherUserId,
            observeMessage: DefaultObserveMessageUseCase(repository: self.repository),
            sendMessage: DefaultSendMessageUseCase(repository: self.repository)
            ))
    }
}

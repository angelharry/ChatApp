//
//  FirebaseSessionProvider.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation
import FirebaseAuth

struct FirebaseSessionProvider: SessionProvider {
    var currentUserId: String? {Auth.auth().currentUser?.uid}
}

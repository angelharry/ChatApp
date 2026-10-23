//
//  SessionProvider.swift
//  ChatApp
//
//  Created by Anju on 10/23/26.
//

import Foundation

protocol SessionProvider {
    var currentUserId: String? {get}
}

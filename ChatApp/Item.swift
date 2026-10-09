//
//  Item.swift
//  ChatApp
//
//  Created by Amitha George on 10/9/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

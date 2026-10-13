//
//  MessageScreenTopHeaderView.swift
//  ChatApp
//
//  Created by Anju on 10/11/26.
//

import SwiftUI

struct MessageScreenTopHeaderView: View {
    let avatar : String
    let name: String
    let status: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "chevron.left")
                .font(.title2)
            
            Image(avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.title3.bold())
                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            HStack(spacing: 24) {
                Image(systemName: "phone")
                Image(systemName: "video")
            }
            .font(.title2)
        }
        .foregroundStyle(.primary)
        .padding(.horizontal)
        .padding(.vertical, 8)
        
    }
}

#Preview {
    MessageScreenTopHeaderView(
        avatar: "Profile Image",
        name: "Username here",
        status: "Active 00m ago"
    )
}

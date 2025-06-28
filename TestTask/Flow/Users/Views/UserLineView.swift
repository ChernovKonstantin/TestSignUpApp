//
//  UserLineView.swift
//  TestTask
//
//  Created by Chernov Kostiantyn on 25.06.2025.
//

import SwiftUI

struct UserLineView: View {
    
    let user: User
    var photo: Image?
    
    var body: some View {
        HStack(alignment: .top) {
            if let photo {
                photo
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 16)
                    
            } else {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .lineLimit(nil)
                    .font(.body2)
                    .foregroundStyle(Color(.black87))
                Text(user.position)
                    .lineLimit(1)
                    .font(.body3)
                    .foregroundColor(Color(.black60))
                    .padding(.bottom, 4)
                Text(user.email)
                    .lineLimit(1)
                    .font(.body3)
                    .foregroundStyle(Color(.black87))
                Text(user.phone)
                    .lineLimit(1)
                    .font(.body3)
                    .foregroundStyle(Color(.black87))
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

#Preview {
    UserLineView(user: User(id: 1, name: "123", email: "1", phone: "1", position: "1", positionId: 11, registrationTimestamp: 1, photo: "1"), photo: Image(systemName: "photo"))
}

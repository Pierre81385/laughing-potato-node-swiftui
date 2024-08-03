//
//  MessageFeedView.swift
//  laughing-potato
//
//  Created by m1_air on 7/30/24.
//

import SwiftUI

struct MessageFeedView: View {
    @Binding var messages: [MessageData]
    @Binding var user: UserData
    
    var body: some View {
        List{
            ForEach(messages) { message in
                if String(describing: message.senderId) == String(describing: user.id) {
                    SenderMessage(message: message)
                } else {
                    MessageFeed(message: message)
                }
            }
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
            .onAppear{
                // Your onAppear code
                
            }
        }
    }
}

//#Preview {
//    MessageFeedView()
//}

struct MessageFeed: View {
    var message: MessageData

    var body: some View {
            HStack {
                VStack.init(alignment: .leading) {
                    Text(message.text)
                    Text(message.senderName).font(.headline)
                }.rotationEffect(.radians(.pi))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                Spacer()
            }.onAppear{
            
            }
        }
}

struct SenderMessage: View {
    var message: MessageData

    var body: some View {
        HStack {
            Spacer()
            VStack.init(alignment: .trailing) {
                Text(message.text)
                Text(message.senderName).font(.headline)
            }
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
        }.onAppear{
        
        }
    }
}

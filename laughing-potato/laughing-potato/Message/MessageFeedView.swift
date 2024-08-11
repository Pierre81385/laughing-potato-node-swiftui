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
        if messages.isEmpty {
            VStack {
                Text("Send a message to get this started!")
                ProgressView()
            }
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messages.reversed(), id: \.id) { message in
                        if String(describing: message.senderId) == String(describing: user.id) {
                            HStack {
                                Spacer()
                                SenderMessage(message: message)
                                    .padding(EdgeInsets(top: 1, leading: 0, bottom: 1, trailing: 4))
                            }
                        } else {
                            HStack {
                                MessageFeed(message: message)
                                    .padding(EdgeInsets(top: 1, leading: 4, bottom: 1, trailing: 0))
                                Spacer()
                            }
                        }
                    }
                    .rotationEffect(.radians(.pi))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                }
                .onAppear {
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: messages) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
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
        GroupBox(content: {
            HStack {
                VStack.init(alignment: .leading) {
                    Text(message.text).fontWeight(.ultraLight)
                    Text(message.senderName).font(.headline)
                }.rotationEffect(.radians(.pi))
                    .scaleEffect(x: -1, y: 1, anchor: .center)
                Spacer()
            }
        }).groupBoxStyle(MessageGroupBoxStyle())
        .fixedSize()
    }
}

struct MessageGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .foregroundColor(.white)
            configuration.content
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(20)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 4, x: 2, y: 2)
    }
}

struct SenderMessage: View {
    var message: MessageData

    var body: some View {
        GroupBox(content: {
            HStack {
                Spacer()
                VStack.init(alignment: .trailing) {
                    Text(message.text).fontWeight(.ultraLight)
                    Text(message.senderName).font(.headline)
                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
            }
        }).groupBoxStyle(SenderGroupBoxStyle())
        .fixedSize()
    }
}

struct SenderGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .foregroundColor(.black)
            configuration.content
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 4, x: 2, y: 2)
    }
}

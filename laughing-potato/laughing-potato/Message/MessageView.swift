//
//  MessageView.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import SwiftUI
import SwiftData

struct MessageView: View {
    @Binding var sender: UserData
    @State var messageManager: MessageViewModel = MessageViewModel()

    
    var body: some View {
        VStack{
            Spacer()
            MessageFeedView(messages: $messageManager.messages, user: $sender)
            HStack{
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "photo.on.rectangle.angled").tint(.black)
                })
                TextField("Message", text: $messageManager.message.text)
                Button(action: {
                    //testing
                    messageManager.message.senderId = sender.id
                    messageManager.message.senderName = sender.name
                    messageManager.message.media = []
                    messageManager.message.locationLat = 0.0
                    messageManager.message.locationLong = 0.0
                    //testing
                    Task{
                        await messageManager.postMessageData(requestBody: messageManager.message)
//                        await messageManager.getMessageData()
                    }
                    SocketService.shared.socket.emit("messageSent", ["message": "\(messageManager.message.text)"])
                }, label: {
                    Image(systemName: "paperplane.circle.fill").tint(.black)
                })
            }.padding()
        }.onAppear{
     
                Task{
                    await messageManager.getMessageData()
                }
            
        }
        .onChange(of: SocketService.shared.message, {
            if(SocketService.shared.message == "updating message list") {
                Task{
                    await messageManager.getMessageData()
                }
            }
        })
    }
}

//#Preview {
//    MessageView().modelContainer(for: UserData.self, inMemory: true)
//}

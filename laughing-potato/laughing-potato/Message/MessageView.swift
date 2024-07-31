//
//  MessageView.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import SwiftUI
import SwiftData

struct MessageView: View {
    @State var messageManager: MessageViewModel = MessageViewModel()
    @State var sender: UserData = UserData(id: "", name: "", timeStamp: 0.0)
    @Query var allUsers: [UserData]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack{
            HStack{
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "photo.on.rectangle.angled").tint(.black)
                })
                TextField("Message", text: $messageManager.message.text)
                Button(action: {
                    //testing
                    messageManager.message.senderId = "test02"
                    messageManager.message.senderName = "testUser"
                    messageManager.message.media = []
                    messageManager.message.locationLat = 0.0
                    messageManager.message.locationLong = 0.0
                    //testing
                    Task{
                        await messageManager.postMessageData(requestBody: messageManager.message)
                    }
                }, label: {
                    Image(systemName: "paperplane.circle.fill").tint(.black)
                })
            }.padding()
        }.onAppear{
            //if(allUsers.isEmpty return the user back to the entry page
            //sender = allUsers[0]
        }
    }
}

#Preview {
    MessageView().modelContainer(for: UserData.self, inMemory: true)
}

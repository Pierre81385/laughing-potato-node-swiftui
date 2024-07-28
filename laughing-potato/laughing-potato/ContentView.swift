//
//  ContentView.swift
//  laughing-potato
//
//  Created by m1_air on 7/28/24.
//

import SwiftUI
import SwiftData
import SocketIO

struct ContentView: View {
    
    var body: some View {
        ZStack{
            VStack{
                Text("Welcome")
                Button(action: {
                    SocketService.shared.socket.emit("press", ["message": "Content view button pressed!"])
                }, label: {
                    Text("Button")
                })
            }
        }.onAppear {
            SocketService.shared.socket.connect()
                }
    }
}



#Preview {
    ContentView()
}

//example from Socket.io

//import SocketIO
//
//let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
//let socket = manager.defaultSocket
//
//socket.on(clientEvent: .connect) {data, ack in
//    print("socket connected")
//}
//
//socket.on("currentAmount") {data, ack in
//    guard let cur = data[0] as? Double else { return }
//    
//    socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//        if data.first as? String ?? "passed" == SocketAckValue.noAck {
//            // Handle ack timeout
//        }
//
//        socket.emit("update", ["amount": cur + 2.50])
//    }
//
//    ack.with("Got your currentAmount", "dude")
//}
//
//socket.connect()

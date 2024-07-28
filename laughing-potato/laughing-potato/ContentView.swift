//
//  ContentView.swift
//  laughing-potato
//
//  Created by m1_air on 7/28/24.
//

import SwiftUI
import SwiftData
import SocketIO

enum SocketConfig {
    static let url = "http://127.0.0.1:4200"
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    let socketManager = SocketManager(
           socketURL: URL(string: SocketConfig.url)!,
           config: [.log(true), .forceWebsockets(true)])
    
    var body: some View {
        ZStack{
            VStack{
                Button(action: {
                    socketManager.defaultSocket.emit("button pressed", ["yooooo"])
                }, label: {
                    Text("Emit")
                })
            }
        }
        .onAppear {
                    setupSocketConnection()
                }
    }
    
    private func setupSocketConnection() {
            // 1
            let socket = socketManager.defaultSocket
            // 2
            socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
            }
            // 4
            socket.connect()
        }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
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

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
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
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

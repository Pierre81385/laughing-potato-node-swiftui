//
//  Socket.IO.swift
//  laughing-potato
//
//  Created by m1_air on 7/28/24.
//

import Foundation
import SocketIO
import Observation

enum SocketConfig {
    static let url = "http://127.0.0.1:4200"
}

@Observable class SocketService {
    
    var message: String = ""
    static let shared = SocketService()
    private let manager: SocketManager
    let socket: SocketIOClient
    
    private init() {
        let url = URL(string: SocketConfig.url)!
        manager = SocketManager(socketURL: url, config: [.log(true), .forceWebsockets(true)])
        socket = manager.defaultSocket
        setupSocketConnection()
    }
    
    private func setupSocketConnection() {
        socket.on(clientEvent: .connect) { data, ack in
            self.message = "Socket connected"
        }
        // Add other event handlers as needed
        socket.on("newUser") {
            data, ack in
            self.message = "updating user list"
        }
        
        socket.on("newMessage") {
            data, ack in
            self.message = "updating message list"
        }
        socket.connect()
    }
    
    deinit {
            socket.disconnect()
        }
}

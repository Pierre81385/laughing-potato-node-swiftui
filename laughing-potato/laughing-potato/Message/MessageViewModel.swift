//
//  MessageViewModel.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import Foundation
import Observation

@Observable class MessageViewModel {
    var message: MessageData = MessageData(senderId: "", senderName: "", text: "", media: [], locationLat: 0.0, locationLong: 0.0)
    var messages: [MessageData] = []
    var baseURL: String = "http://127.0.0.1:3000"
    
    enum NetworkError: Error {
        case badUrl
        case invalidRequest
        case badResponse
        case badStatus
        case failedToDecodeResponse
        case failedToEncodeRequest
    }
    
    func getMessageData() async {
          do {
              guard let url = URL(string: "\(baseURL)/message/") else { throw NetworkError.badUrl }
              let (data, response) = try await URLSession.shared.data(from: url)
              guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
              guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
              let decodedResponse = try JSONDecoder().decode([MessageData].self, from: data)
              messages = decodedResponse
          } catch NetworkError.badUrl {
              print("There was an error creating the URL")
          } catch NetworkError.badResponse {
              print("Did not get a valid response")
          } catch NetworkError.badStatus {
              print("Did not get a 2xx status code from the response")
          } catch NetworkError.failedToDecodeResponse {
              print("Failed to decode response into the given type")
          } catch {
              print("An error occurred downloading the data")
          }
      }
    
    func postMessageData(requestBody: MessageData) async -> Void {
        do {
            guard let url = URL(string: "\(baseURL)/message/send") else { throw NetworkError.badUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONEncoder().encode(requestBody) else { throw NetworkError.failedToEncodeRequest }
            request.httpBody = httpBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(String.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            message.text = ""
            SocketService.shared.socket.emit("messageSent", ["message": decodedResponse])
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.failedToEncodeRequest {
            print("Failed to encode the request body")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occurred sending the data")
        }
        
        return
    }
}

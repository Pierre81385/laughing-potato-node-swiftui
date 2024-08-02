//
//  MessageModel.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import Foundation
import SwiftData

@Model class MessageData: Codable {
    var senderId: String
    var senderName: String
    var text: String
    var media: [String]
    var locationLat: Double
    var locationLong: Double
    
    init(senderId: String, senderName: String, text: String, media: [String], locationLat: Double, locationLong: Double) {
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.media = media
        self.locationLat = locationLat
        self.locationLong = locationLong
    }
    
    enum CodingKeys: String, CodingKey {
           case senderId
           case senderName
           case text
           case media
           case locationLat
           case locationLong
           case createdAt
       }
       
       required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           senderId = try container.decode(String.self, forKey: .senderId)
           senderName = try container.decode(String.self, forKey: .senderName)
           text = try container.decode(String.self, forKey: .text)
           media = try container.decode([String].self, forKey: .media)
           locationLat = try container.decode(Double.self, forKey: .locationLat)
           locationLong = try container.decode(Double.self, forKey: .locationLong)
       }
       
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(senderId, forKey: .senderId)
           try container.encode(senderName, forKey: .senderName)
           try container.encode(text, forKey: .text)
           try container.encode(media, forKey: .media)
           try container.encode(locationLat, forKey: .locationLat)
           try container.encode(locationLong, forKey: .locationLong)
       }
}

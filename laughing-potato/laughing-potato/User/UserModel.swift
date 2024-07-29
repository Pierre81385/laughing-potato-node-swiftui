//
//  UserModel.swift
//  laughing-potato
//
//  Created by m1_air on 7/29/24.
//

import Foundation
import SwiftData

@Model class UserData {
    var id: String = UUID().uuidString
    var name: String
    var timeStamp: Double = Date.now.timeIntervalSince1970
    
    init(id: String, name: String, timeStamp: Double) {
        self.id = id
        self.name = name
        self.timeStamp = timeStamp
    }
}

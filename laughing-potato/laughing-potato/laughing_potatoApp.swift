//
//  laughing_potatoApp.swift
//  laughing-potato
//
//  Created by m1_air on 7/28/24.
//

import SwiftUI
import SwiftData

@main
struct laughing_potatoApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserData.self,
            MessageData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            UserView()
        }
        .modelContainer(sharedModelContainer)
    }
}

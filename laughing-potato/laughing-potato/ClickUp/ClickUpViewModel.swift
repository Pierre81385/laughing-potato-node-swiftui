//
//  ClickUp.swift
//  laughing-potato
//
//  Created by m1_air on 8/3/24.
//

import Foundation
import Observation

@Observable class ClickUp {
    
    var task: ClickUpTask?
    
    func getTask(task_id: String, token: String) {
            guard let url = URL(string: "https://api.clickup.com/api/v2/task/\(task_id)") else { fatalError("Missing URL") }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(token, forHTTPHeaderField: "Authorization")

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }

                guard let response = response as? HTTPURLResponse else { return }

                if response.statusCode == 200 {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        do {
                            let decodedTaskResponse = try JSONDecoder().decode(ClickUpTask
                                .self, from: data)
                            self.task = decodedTaskResponse
                        } catch let error {
                            print("Error decoding: ", error)
                        }
                    }
                }
            }

            dataTask.resume()
        }
}

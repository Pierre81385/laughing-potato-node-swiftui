//
//  API.swift
//  laughing-potato
//
//  Created by m1_air on 7/28/24.
//

import Foundation
import Observation

@Observable class NetworkManager {
    enum NetworkError: Error {
        case badUrl
        case invalidRequest
        case badResponse
        case badStatus
        case failedToDecodeResponse
        case failedToEncodeRequest
    }
    
    func getData<T: Codable>(fromURL: String) async -> T? {
            do {
                guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
                guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                
                return decodedResponse
            } catch NetworkError.badUrl {
                print("There was an error creating the URL")
            } catch NetworkError.badResponse {
                print("Did not get a valid response")
            } catch NetworkError.badStatus {
                print("Did not get a 2xx status code from the response")
            } catch NetworkError.failedToDecodeResponse {
                print("Failed to decode response into the given type")
            } catch {
                print("An error occured downloading the data")
            }
            
            return nil
        }
    
    func postData<T: Codable, U: Encodable>(toURL: String, requestBody: U) async -> T? {
        do {
            guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONEncoder().encode(requestBody) else { throw NetworkError.failedToEncodeRequest }
            request.httpBody = httpBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
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
        
        return nil
    }
    
    func putData<T: Codable, U: Encodable>(toURL: String, requestBody: U) async -> T? {
        do {
            guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONEncoder().encode(requestBody) else { throw NetworkError.failedToEncodeRequest }
            request.httpBody = httpBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
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
        
        return nil
    }
    
    func patchData<T: Codable, U: Encodable>(toURL: String, requestBody: U) async -> T? {
        do {
            guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONEncoder().encode(requestBody) else { throw NetworkError.failedToEncodeRequest }
            request.httpBody = httpBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
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
        
        return nil
    }
    
    func deleteData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
            
            return decodedResponse
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
        } catch {
            print("An error occurred sending the data")
        }
        
        return nil
    }
}

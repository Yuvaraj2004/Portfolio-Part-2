//
//  Networking.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 23/11/2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T?, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error requesting data: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

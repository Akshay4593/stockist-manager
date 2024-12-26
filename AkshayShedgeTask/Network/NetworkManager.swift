//
//  NetworkManager.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 24/12/24.
//

import Foundation

protocol NetworkService {
    
    func performRequest<T: Decodable>(path: ConnectionRepresentable,
                                      queryParams: [String:String]?,
                                      body: Data?,
                                      completion: @escaping (Result<T, CustomError>) -> Void)
    
}


class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    
    private init() {
    }
    
    func performRequest<T: Decodable>(path: ConnectionRepresentable,
                           queryParams: [String:String]?,
                           body: Data?,
                           completion: @escaping (Result<T, CustomError>) -> Void) {
        
        guard var url = path.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let queryParam = queryParams {
            url = url.withQueries(queryParam) ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = path.method.rawValue
        
        if let body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            if let error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
}

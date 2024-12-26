//
//  CustomError.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case noData
    case decodingError
    case requestFailed(Error)
    case noInternet
    
    var errroMessage: String {
        
        switch self {
        case .invalidURL:
            "URL is invalid"
        case .noData:
            "No results found. Please try again."
        case .decodingError:
            "Unable to decode data."
        case .requestFailed(let error):
            error.localizedDescription
        case .noInternet:
            "No internet connection."
        }
    }
    
    var description: String {
        self.localizedDescription
    }
    
}

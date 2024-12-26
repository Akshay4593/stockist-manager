//
//  HomeNetworking.swift
//  AkshayShedgeTask
//
//  Created by Akshay Shedge on 26/12/24.
//

import Foundation

protocol ConnectionRepresentable {
   
    var path: String { get }
        
    /// HTTP Method for the connection request.
    var method: HTTPMethod { get }
    
    /// HTTP Method for the connection request.
    var url: URL? { get }
    
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HomeNetworking: ConnectionRepresentable {
    
    case usersHoldings
    
    var path: String {
        switch self {
        case .usersHoldings:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .usersHoldings:
            return .get
            
        }
    }
    
    var url: URL? {
        URL(string: APIConstants.baseURL + path)
    }
    
}


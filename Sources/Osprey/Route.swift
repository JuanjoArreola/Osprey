//
//  Route.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public enum Route {
    case get(String)
    case post(String)
    case put(String)
    case delete(String)
    case head(String)
    case patch(String)
    case options(String)
    
    func getURL() throws -> URL {
        switch self {
        case .get(let string): return try url(from: string)
        case .post(let string): return try url(from: string)
        case .put(let string): return try url(from: string)
        case .delete(let string): return try url(from: string)
        case .head(let string): return try url(from: string)
        case .patch(let string): return try url(from: string)
        case .options(let string): return try url(from: string)
        }
    }
    
    var httpMethod: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        case .patch: return "PATCH"
        case .options: return "OPTIONS"
        }
    }
    
    private func url(from string: String) throws -> URL {
        if let url = URL(string: string) {
            return url
        }
        throw RepositoryError.invalidURL(url: string)
    }
}

public enum RepositoryError: Error {
    case invalidURL(url: String)
    case encodingError
    case networkConnection
}

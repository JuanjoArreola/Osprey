//
//  Route.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public enum RoutingError: Error {
    case invalidURL(url: String)
    case encodingError
    case invalidURLQuery
}

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
        case
        .get(let string),
        .post(let string),
        .put(let string),
        .delete(let string),
        .head(let string),
        .patch(let string),
        .options(let string):
            guard let url = URL(string: string) else {
                throw RoutingError.invalidURL(url: string)
            }
            return url
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
}

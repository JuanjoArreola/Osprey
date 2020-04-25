//
//  Resource.swift
//  Osprey
//
//  Created by JuanJo on 24/04/20.
//

import Foundation

public protocol BaseAPI {
    static var baseURL: String { get }
}

public extension BaseAPI {
    func get(endpoint: String) -> Route {
        return Route.get(Self.baseURL + endpoint)
    }

    func post(endpoint: String) -> Route {
        return Route.post(Self.baseURL + endpoint)
    }
    
    func put(endpoint: String) -> Route {
        return Route.put(Self.baseURL + endpoint)
    }
    
    func delete(endpoint: String) -> Route {
        return Route.delete(Self.baseURL + endpoint)
    }
    
    func head(endpoint: String) -> Route {
        return Route.head(Self.baseURL + endpoint)
    }
    
    func patch(endpoint: String) -> Route {
        return Route.patch(Self.baseURL + endpoint)
    }
    
    func options(endpoint: String) -> Route {
        return Route.options(Self.baseURL + endpoint)
    }
}

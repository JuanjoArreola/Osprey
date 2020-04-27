//
//  Resource.swift
//  Osprey
//
//  Created by JuanJo on 24/04/20.
//

import Foundation

public protocol BaseAPI {
    var baseURL: String { get }
}

public extension BaseAPI {
    func get(endpoint: String) -> Route {
        return Route.get(baseURL + endpoint)
    }

    func post(endpoint: String) -> Route {
        return Route.post(baseURL + endpoint)
    }
    
    func put(endpoint: String) -> Route {
        return Route.put(baseURL + endpoint)
    }
    
    func delete(endpoint: String) -> Route {
        return Route.delete(baseURL + endpoint)
    }
    
    func head(endpoint: String) -> Route {
        return Route.head(baseURL + endpoint)
    }
    
    func patch(endpoint: String) -> Route {
        return Route.patch(baseURL + endpoint)
    }
    
    func options(endpoint: String) -> Route {
        return Route.options(baseURL + endpoint)
    }
}

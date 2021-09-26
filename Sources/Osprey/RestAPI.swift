//
//  RestAPI.swift
//  Osprey
//
//  Created by JuanJo on 24/04/20.
//

import Foundation

public protocol RestAPI {
    var baseURL: String { get }
    var resource: String { get }
}

public extension RestAPI {
    
    func all() -> Route {
        return Route.get("\(baseURL)/\(resource)")
    }
    
    func create() -> Route {
        return Route.post("\(baseURL)/\(resource)")
    }
    
    func update() -> Route {
        return Route.patch("\(baseURL)/\(resource)")
    }
    
    func delete() -> Route {
        return Route.delete("\(baseURL)/\(resource)")
    }
    
    func get(endpoint: String) -> Route {
        return Route.get("\(baseURL)/\(resource)\(endpoint)")
    }

    func post(endpoint: String) -> Route {
        return Route.post("\(baseURL)/\(resource)\(endpoint)")
    }
    
    func put(endpoint: String) -> Route {
        return Route.put("\(baseURL)/\(resource)\(endpoint)")
    }
    
    func delete(endpoint: String) -> Route {
        return Route.delete("\(baseURL)/\(resource)\(endpoint)")
    }
    
    func head(endpoint: String) -> Route {
        return Route.head("\(baseURL)/\(resource)\(endpoint)")
    }
    
    func patch(endpoint: String) -> Route {
        return Route.patch("\(baseURL)/\(resource)\(endpoint)")
    }
    
    func options(endpoint: String) -> Route {
        return Route.options("\(baseURL)/\(resource)\(endpoint)")
    }
}

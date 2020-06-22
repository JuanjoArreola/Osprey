//
//  HttpRequester.swift
//  Osprey
//
//  Created by JuanJo on 22/06/20.
//

import Foundation

open class HttpRequester {
    open var cachePolicy: URLRequest.CachePolicy?
    open var timeoutInterval: TimeInterval?
    open var allowsCellularAccess: Bool?
    open var session: URLSession?
    
    func request(route: Route, parameters: RequestParameters?, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) throws -> URLSessionDataTask {
        try parameters?.preprocess()
        var request = URLRequest(url: try route.getURL(with: parameters))
        request.httpBody = try parameters?.getData()
        parameters?.headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        
        request.httpMethod = route.httpMethod
        request.cachePolicy = cachePolicy ?? request.cachePolicy
        request.timeoutInterval = timeoutInterval ?? request.timeoutInterval
        request.allowsCellularAccess = allowsCellularAccess ?? request.allowsCellularAccess
        
        let session = self.session ?? URLSession.shared
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
        
        return task
    }
}

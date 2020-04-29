//
//  AbstractAPI.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation
import ShallowPromises

extension URLSessionDataTask: Cancellable {}

private let processingQueue = DispatchQueue(label: "com.osprey.ProcessingQueue", attributes: .concurrent)

open class AbstractAPI: BaseRepository {
    
    public let responseParser: ResponseParser
    open var responseQueue = DispatchQueue.main
    
    public init(responseParser: ResponseParser) {
        self.responseParser = responseParser
        super.init()
    }
    
    open func request<T: Decodable>(route: Route, parameters: RequestParameters? = nil) -> Promise<T> {
        let promise = Promise<T>()
        processingQueue.async {
            do {
                promise.littlePromise = try self.request(route: route, parameters: parameters,
                                                         completion: self.parseClosure(for: promise))
            } catch {
                promise.complete(with: error, in: self.responseQueue)
            }
        }
        return promise
    }
    
    func parseClosure<T: Decodable>(for promise: Promise<T>) -> ((Data?, URLResponse?, Error?) -> Void) {
        return { (data, response, error) in
            do {
                if let error = try self.parseError(data: data, response: response, error: error) {
                    promise.complete(with: error, in: self.responseQueue)
                } else if let data = data {
                    let result: T = try self.responseParser.getInstance(from: data, response: response)
                    promise.fulfill(with: result, in: self.responseQueue)
                } else {
                    promise.complete(with: ResponseError.emptyResponse, in: self.responseQueue)
                }
            } catch {
                promise.complete(with: error, in: self.responseQueue)
            }
        }
    }
    
    // MARK: - Parse error
    
    public func parseError(data: Data?, response: URLResponse?, error: Error?) throws -> Error? {
        if let error = error {
            return error
        }
        if let code = (response as? HTTPURLResponse)?.statusCode, !(200..<400).contains(code) {
            if let data = data, let error = try responseParser.getError(from: data, response: response) {
                return error
            }
            if let error = parseError(code: code, data: data, response: response) {
                return error
            }
            return ResponseError.httpError(statusCode: code, content: data)
        }
        return nil
    }
    
    open func parseError(code: Int, data: Data?, response: URLResponse?) -> Error? {
        switch code {
        case 404:
            if let url = response?.url {
                return ResponseError.notFound(url: url)
            }
            return nil
        default:
            return nil
        }
    }
}

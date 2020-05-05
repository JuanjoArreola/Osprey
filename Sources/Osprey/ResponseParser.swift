//
//  ResponseParser.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public protocol ResponseParser {
    var acceptHeader: String? { get }
    
    func getError(from data: Data?, response: URLResponse?) throws -> Error?
    func getInstance<T: Decodable>(from data: Data, response: URLResponse?) throws -> T
}

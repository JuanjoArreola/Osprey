//
//  BodyConvertible.swift
//  
//
//  Created by JuanJo on 25/09/21.
//

import Foundation

public protocol BodyConvertible {
    var headers: [String: String]? { get }
    var data: Data { get }
}

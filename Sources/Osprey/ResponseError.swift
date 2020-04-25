//
//  ResponseError.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public enum ResponseError: Error {
    case httpError(statusCode: Int, content: Data?)
    case notFound(url: URL)
    case invalidDate(string: String?)
    case emptyResponse
}

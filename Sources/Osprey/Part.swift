//
//  Part.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class Part {
    var type: String
    var data: Data?
    var attributes: [String: Any]?
    
    public init(type: String, data: Data?, attributes: [String: Any]?) {
        self.type = type
        self.data = data
        self.attributes = attributes
    }
    
    public convenience init(mimeType type: MimeType, data: Data, attributes: [String: Any]?) {
        self.init(type: type.rawValue, data: data, attributes: attributes)
    }
    
    func encode(withBoundary boundary: String) throws -> Data {
        guard let data = data else {
            throw MultipartError.emptyData
        }
        var content = Data()
        try content.append("--\(boundary)\r\n")
        
        var disposition = ["Content-Disposition: form-data"]
        disposition.append(contentsOf: attributes?.map({ "\($0.key)=\"\($0.value)\"" }) ?? [])
        try content.append(disposition.joined(separator: "; "))
        
        try content.append("Content-Type: \(type)\r\n\r\n")
        content.append(data)
        return try content.append("\r\n")
    }
}

public enum MimeType: String {
    case bmp = "image/bmp"
    case css = "text/css"
    case csv = "text/csv"
    case html = "text/html"
    case json = "application/json"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case text = "text/plain"
}

extension Data {
    @discardableResult
    mutating func append(_ string: String) throws -> Self {
        guard let data = string.data(using: .utf8) else {
            throw MultipartError.dataEncoding
        }
        append(data)
        return self
    }
}

public enum MultipartError: Error {
    case dataEncoding
    case emptyData
}

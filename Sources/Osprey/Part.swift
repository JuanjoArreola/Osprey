//
//  Part.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class Part {
    var type: String
    var name: String
    var filename: String
    var data: Data
    
    public init(type: String, name: String, filename: String, data: Data) {
        self.type = type
        self.name = name
        self.filename = filename
        self.data = data
    }
    
    public convenience init(mimeType type: MimeType, name: String, filename: String, data: Data) {
        self.init(type: type.rawValue, name: name, filename: filename, data: data)
    }
    
    func encode(withBoundary boundary: String) throws -> Data {
        var content = Data()
        try content.append(string: "--\(boundary)\r\n")
        try content.append(string: "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        try content.append(string: "Content-Type: \(type)\r\n\r\n")
        content.append(data)
        try content.append(string: "\r\n")
        return content
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
    mutating func append(string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw MultipartError.dataEncoding
        }
        append(data)
    }
}

public enum MultipartError: Error {
    case dataEncoding
}

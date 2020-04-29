//
//  DeferredPart.swift
//  Osprey
//
//  Created by JuanJo on 29/04/20.
//

import Foundation

open class DeferredPart: Part {
    
    var dataClosure: (() -> Data?)?
    
    override func encode(withBoundary boundary: String) throws -> Data {
        if data == nil {
            self.data = dataClosure?()
        }
        return try super.encode(withBoundary: boundary)
    }
}

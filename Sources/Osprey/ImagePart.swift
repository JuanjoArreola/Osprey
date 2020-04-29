//
//  PNGPart.swift
//  Osprey
//
//  Created by JuanJo on 28/04/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public final class PNGPart: DeferredPart {
    
    init(image: UIImage, attributes: [String: Any]? = nil) {
        super.init(type: "image/png", data: nil, attributes: attributes)
        dataClosure = { image.pngData() }
    }
}

public final class JPEGPart: DeferredPart {
    
    init(image: UIImage, compressionQuality: CGFloat = 1, attributes: [String: Any]? = nil) {
        super.init(type: "image/jpeg", data: nil, attributes: attributes)
        dataClosure = { image.jpegData(compressionQuality: compressionQuality) }
    }
}

#endif

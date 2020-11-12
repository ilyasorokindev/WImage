//
//  WErrorHandler.swift
//  WImage
//
//  Created by Ilya Sorokin on 12.11.2020.
//

import Foundation

public protocol WErrorHandlerProtocol {
    
    func haandle(error: Error, data: Data?) -> WPlatformImage?
    
}

class WErrorHandler: WErrorHandlerProtocol {
    
    func haandle(error: Error, data: Data?) -> WPlatformImage? {
        debugPrint(error)
        if let data = data {
            debugPrint(data)
        }
        return nil
    }
    
}

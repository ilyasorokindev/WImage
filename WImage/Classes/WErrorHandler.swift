//
//  WErrorHandler.swift
//  WImage
//
//  Created by Ilya Sorokin on 12.11.2020.
//

import Foundation

public protocol WErrorHandlerProtocol {

    func haandle(error: Error) -> WPlatformImage?

}

class WErrorHandler: WErrorHandlerProtocol {

    func haandle(error: Error) -> WPlatformImage? {
        debugPrint(error)
        return nil
    }

}

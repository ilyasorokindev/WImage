//
//  WImageHandler.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//

import Foundation

public protocol WImageHandlerProtocol {
    func handle(item: WItem) -> URL
}

internal class WImageHandler: WImageHandlerProtocol {
    func handle(item: WItem) -> URL {
        return item.url
    }
}

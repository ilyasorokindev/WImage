//
//  WURLHandler.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//

import Foundation

public protocol WURLHandlerProtocol {
    func handle(item: WItem) -> URL
}

internal class WURLHandler: WURLHandlerProtocol {
    func handle(item: WItem) -> URL {
        return item.url
    }
}

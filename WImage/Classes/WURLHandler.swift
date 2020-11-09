//
//  WURLHandler.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//

import Foundation

public protocol WURLHandlerProtocol {
    func handle(url: URL, width: Int?, height: Int?) -> URL
}

internal class WURLHandler: WURLHandlerProtocol {
    func handle(url: URL, width: Int?, height: Int?) -> URL {
        if width == nil && height == nil {
          return url
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        var queryItems = [URLQueryItem]()
        if let width = width {
          queryItems.append(URLQueryItem(name: "width", value: String(width)))
        }
        if let height = height {
          queryItems.append(URLQueryItem(name: "height", value: String(height)))
        }
        components.queryItems = queryItems
        guard let newUrl = components.url else {
           return url
        }
        return newUrl
    }
}

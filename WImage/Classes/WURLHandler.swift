//
//  WURLHandler.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//

import Foundation

public protocol WURLHandlerProtocol {
    func handle(path: String,
                width: Int?,
                height: Int?,
                filter: Int?) -> URL?
}

internal class WURLHandler: WURLHandlerProtocol {
    
    func handle(path: String,
                width: Int?,
                height: Int?,
                filter: Int?) -> URL? {
        guard let url = URL(string: path) else {
            return nil
        }
        
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
        if let filter = filter {
            queryItems.append(URLQueryItem(name: "filter", value: String(filter)))
        }
        components.queryItems = queryItems
        guard let newUrl = components.url else {
            return url
        }
        return newUrl
    }
}

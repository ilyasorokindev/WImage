//
//  WPostHandler.swift
//  WImage
//
//  Created by Ilya Sorokin on 14.09.2021.
//

import UIKit

public protocol WPostHandlerProtocol: AnyObject {
    
    func handle(url: URL, data: Data) -> WPlatformImage?
    
}

class WPostHandler: WPostHandlerProtocol {
    
    func handle(url: URL, data: Data) -> WPlatformImage? {
       return WPlatformImage(data: data, scale: Constants.scale)
    }

}

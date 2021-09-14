//
//  WPostHandler.swift
//  WImage
//
//  Created by Ilya Sorokin on 14.09.2021.
//

import UIKit

public protocol WPostHandlerProtocol: AnyObject {
    
    func handle(url: URL, image: WPlatformImage) -> WPlatformImage
    
}

class WPostHandler: WPostHandlerProtocol {
    
    func handle(url: URL, image: WPlatformImage) -> WPlatformImage {
        return image
    }

}

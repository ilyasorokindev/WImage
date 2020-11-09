//
//  types.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//
import Foundation

enum Constants {
    static let cacheName = "WImageData"
}

#if os(macOS)
import Cocoa

public typealias WPlatformImage = NSImage

extension Constants {
    static let scale = 1
}

extension NSImage {
    convenience init?(data: Data, scale: Int) {
        self.init(data: data)
    }
}

#else

import UIKit

public typealias WPlatformImage = UIImage
public typealias WPlatformFloat = CGFloat

extension Constants {
    static let scale = UIScreen.main.scale
}
#endif

public typealias WCompletion = (WPlatformImage?) -> Void

public enum Priority {
    case low
    case normal
}

//
//  types.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//
import Foundation

#if os(macOS)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias WPlatformImage = NSImage
#else
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias WPlatformImage = UIImage
#endif

public typealias WCompletion = (WPlatformImage) -> Void

public enum Priority {
    case low
    case normal
}

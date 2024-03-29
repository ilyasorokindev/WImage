//
//  WItem.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//
import Foundation

public class WItem {

    public let id: UInt
    public let path: String
    internal let completion: WCompletion?
    internal(set) public var width: WPlatformFloat?
    internal(set) public var height: WPlatformFloat?
    internal(set) public var filter: String?
    internal(set) public var priority = Priority.normal

    internal init(id: UInt,
                  path: String,
                  completion: WCompletion?) {
        self.id = id
        self.path = path
        self.completion = completion
    }

}

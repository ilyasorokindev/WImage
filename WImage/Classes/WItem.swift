//
//  WItem.swift
//  
//
//  Created by Ilya Sorokin on 06.11.2020.
//
import Foundation

public class WItem {
   
    public let id: UInt
    public let url: URL
    internal let completion: WCompletion?
    internal(set) public var width: CGFloat?
    internal(set) public var height: CGFloat?
    internal(set) public var priority = Priority.normal
    
    internal init(id: UInt,
                  url: URL,
                  completion: WCompletion?) {
        self.id = id
        self.url = url
        self.completion = completion
    }
    
}

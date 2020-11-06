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
    private let completion: WCompletion?
    internal(set) public var width: Int?
    internal(set) public var height: Int?
    internal(set) public var priority: Priority
    
    internal init(id: UInt,
                  url: URL,
                  completion: WCompletion?,
                  width: Int?,
                  height: Int?) {
        
    }
    
}

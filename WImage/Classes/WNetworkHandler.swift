//
//  WNetworkHandler.swift
//  
//
//  Created by Ilya Sorokin on 07.11.2020.
//

import Foundation

// URL, Image, Image data, error, loading count
public typealias WFinishedAction = (URL, Data?, Error?, Int) -> Void

public protocol WLoadingItemProtocol {
    func cancel()
    func start()
}

public protocol WNetworkHandlerProtocol {

    var loadingCount: Int { get }
    var maxLoadingCount: Int { get }

    func load(url: URL, completion: @escaping WFinishedAction) -> WLoadingItemProtocol

}

internal class WNetworkHandler: WNetworkHandlerProtocol {

    var loadingCount: Int {
        self.counterLocker.lock()
        defer { self.counterLocker.unlock() }
        return self.counter
    }

    let maxLoadingCount: Int

    private let session: URLSession
    private var counter = 0
    private let counterLocker = NSLock()

    init() {
        let configuration = URLSessionConfiguration.ephemeral
        self.session = URLSession(configuration: configuration)
        self.maxLoadingCount = configuration.httpMaximumConnectionsPerHost
    }

    func load(url: URL, completion: @escaping WFinishedAction) -> WLoadingItemProtocol {
        self.updateCounter(value: 1)
        let task = self.session.dataTask(with: url) { (data, _, error) in
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
              return
            }
            completion(url,
                       {
                        return data
                       }(),
                       {
                        if let error = error as NSError?, error.code == NSURLErrorCancelled {
                            return nil
                        }
                        return error
                       }(),
                       self.updateCounter(value: -1))
        }
        return task
    }

    @discardableResult
    private func updateCounter(value: Int) -> Int {
        self.counterLocker.lock()
        self.counter += value
        defer { self.counterLocker.unlock() }
        return self.counter
    }
}

extension URLSessionTask: WLoadingItemProtocol {

    public func start() {
        self.resume()
    }

}

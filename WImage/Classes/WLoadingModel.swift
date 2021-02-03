//
//  WLoadingModel.swift
//  WImage
//
//  Created by Ilya Sorokin on 09.11.2020.
//

import Foundation

class WLoadingModel {

    var isEmpty: Bool {
        return items.isEmpty
    }

    private var items = [UInt: WCompletion?]()
    private let loadingItem: WLoadingItemProtocol

    init(loadingItem: WLoadingItemProtocol) {
        self.loadingItem = loadingItem
    }

    @discardableResult
    func cancel() -> WLoadingModel {
        self.loadingItem.cancel()
        return self
    }

    @discardableResult
    func add(id: UInt, completion: WCompletion?) -> WLoadingModel {
        assert(items[id] == nil)
        self.items[id] = completion
        return self
    }

    @discardableResult
    func remove(id: UInt) -> WLoadingModel {
        self.items[id] = nil
        return self
    }

    @discardableResult
    func execute(image: WPlatformImage?) -> WLoadingModel {
        assert(!items.isEmpty)
        self.items.values.forEach { completion in
            completion?(image)
        }
        self.items.removeAll()
        return self
    }

}

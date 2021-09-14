import Foundation

public class WImage {
    public static let shared = WImage()

    private let counterLocker = NSLock()
    private var counter: UInt = 0

    private var urlHandler: WURLHandlerProtocol = WURLHandler()
    private var storageHanler: WStorageHandlerProtocol = WStorageHandler()
    private var networkHandler: WNetworkHandlerProtocol = WNetworkHandler()
    private var postHandler: WPostHandlerProtocol = WPostHandler()
    private var errorHandler: WErrorHandlerProtocol = WErrorHandler()

    private let loadingLocker = NSLock()
    private(set) internal var loadingItems = [URL : WLoadingModel]()

    private init() {
    }

    @discardableResult
    public func setURLHandler(urlHandler: WURLHandlerProtocol) -> WImage {
        self.urlHandler = urlHandler
        return self
    }

    @discardableResult
    public func setStorageHanler(storageHanler: WStorageHandlerProtocol) -> WImage {
        self.storageHanler = storageHanler
        return self
    }

    @discardableResult
    public func setNetworkHandler(networkHandler: WNetworkHandlerProtocol) -> WImage {
        self.networkHandler = networkHandler
        return self
    }

    @discardableResult
    public func setPostHandler(postHandler: WPostHandlerProtocol) -> WImage {
        self.postHandler = postHandler
        return self
    }
    
    @discardableResult
    public func setErrorHandler(errorHandler: WErrorHandlerProtocol) -> WImage {
        self.errorHandler = errorHandler
        return self
    }

    @discardableResult
    public func load(path: String,
                     width: WPlatformFloat? = nil,
                     height: WPlatformFloat? = nil,
                     filter: Int? = nil,
                     priority: Priority = .normal,
                     completion: WCompletion? = nil) -> WItem {

        let item = WItem(id: self.createID(),
                         path: path,
                         completion: completion)
        self.updateItem(item: item, width: width, height: height, filter: filter,
                        priority: priority, resetOther: true)
        self.loadItem(item: item)
        return item
    }

    @discardableResult
    public func update(item: WItem,
                       width: WPlatformFloat? = nil,
                       height: WPlatformFloat? = nil,
                       filter: Int? = nil,
                       priority: Priority? = nil,
                       resetOther: Bool = false) -> WImage {
        self.cancel(item: item)
        self.updateItem(item: item, width: width, height: height, filter: filter,
                        priority: priority, resetOther: resetOther)
        self.loadItem(item: item)
        return self
    }
    

    @discardableResult
    public func cancel(item: WItem) -> WImage {
        guard let url = self.makeUrl(item: item) else {
            return self
        }
        self.loadingLocker.lock()
        if self.loadingItems[url]?.remove(id: item.id).isEmpty ?? false {
            self.loadingItems[url] = nil
        }
        self.loadingLocker.unlock()
        return self
    }

    @discardableResult
    public func clearCache() -> WImage {
        self.storageHanler.removeAllImages()
        return self
    }
    
    private func createID() -> UInt {
        self.counterLocker.lock()
        self.counter += 1
        defer { self.counterLocker.unlock() }
        return self.counter
    }

    private func makeUrl(item: WItem) -> URL? {
        let width: Int? = item.width != nil ? Int(item.width! * Constants.scale) : nil
        let height: Int? = item.height != nil ? Int(item.height! * Constants.scale) : nil
        return self.urlHandler.handle(path: item.path, width: width, height: height, filter: item.filter)
    }

    private func updateItem(item: WItem,
                            width: WPlatformFloat?,
                            height: WPlatformFloat?,
                            filter: Int?,
                            priority: Priority?,
                            resetOther: Bool) {
        if resetOther {
            item.width = width ?? 0 > 0 ? width : nil
            item.height = height ?? 0 > 0 ? height : nil
            item.filter = filter
            item.priority =  priority ?? .normal
        } else {
            if width != nil {
                item.width = width ?? 0 > 0 ? width : nil
            }
            if height != nil {
                item.height = height ?? 0 > 0 ? height : nil
            }
            if filter != nil {
                item.filter = filter
            }
            item.priority = priority ?? item.priority
        }
    }

    private func loadItem(item: WItem) {
        guard let url = self.makeUrl(item: item) else {
            return
        }
        if let image = self.storageHanler.getImage(url: url) {
            item.completion?(image)
            return
        }
        self.download(url: url, id: item.id, completion: item.completion)
    }

    private func download(url: URL, id: UInt, completion: WCompletion?) {
        self.loadingLocker.lock()
        let loading = self.loadingItems[url] != nil
        if loading {
            self.loadingItems[url]?.add(id: id, completion: completion)
            self.loadingLocker.unlock()
            return
        }
        let item = self.networkHandler.load(url: url, completion: { url, image, error, count in
            self.downloaded(url: url, image: image, error: error, count: count)
        })
        self.loadingItems[url] =  WLoadingModel(loadingItem: item).add(id: id, completion: completion)
        self.loadingLocker.unlock()
        item.start()
    }

    private func downloaded(url: URL, image: WPlatformImage?, error: Error?, count: Int) {
        var newImage: WPlatformImage?
        if let image = image {
            let image = self.postHandler.handle(url: url, image: image)
            self.storageHanler.saveImage(url: url, image: image)
            newImage = image
        } else if let error = error {
            newImage = self.errorHandler.haandle(error: error)
        }
        DispatchQueue.main.async {
            self.loadingLocker.lock()
            self.loadingItems[url]?.execute(image: newImage)
            self.loadingItems[url] = nil
            self.loadingLocker.unlock()
        }
    }
}

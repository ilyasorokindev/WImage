import Foundation


public class WImage {
    public static let shared = WImage()
    
    private let counterLocker = NSLock()
    private var counter: UInt = 0
    
    private var urlHandler: WURLHandlerProtocol = WURLHandler()
    private var storageHanler: WStorageHandlerProtocol = WStorageHandler()
    private var networkHandler: WNetworkHandlerProtocol = WNetworkHandler()
    
    private let loadingLocker = NSLock()
    private(set) internal var loadingItems = [URL : [UInt : WCompletion?]]()
    
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
    public func load(url: URL,
                     width: WPlatformFloat? = nil,
                     height: WPlatformFloat? = nil,
                     priority: Priority = .normal,
                     completion: WCompletion? = nil) -> WItem {
        
        let item = WItem(id: self.createID(),
                         url: url,
                         completion: completion)
        self.updateItem(item: item, width: width, height: height,
                        priority: priority, resetOther: true)
        self.loadItem(item: item)
        return item
    }
    
    @discardableResult
    public func update(item:  WItem,
                       width: WPlatformFloat? = nil,
                       height: WPlatformFloat? = nil,
                       priority: Priority? = nil,
                       resetOther: Bool = false) -> WImage {
        self.cancel(item: item)
        self.updateItem(item: item, width: width, height: height,
                        priority: priority, resetOther: resetOther)
        self.loadItem(item: item)
        return self
    }
    
    @discardableResult
    public func cancel(item:  WItem) -> WImage  {
        let url = self.makeUrl(item: item)
        
        return self
    }
    
    private func createID() -> UInt {
        self.counterLocker.lock()
        self.counter += 1
        defer { self.counterLocker.unlock() }
        return self.counter
    }
   
    private func makeUrl(item:  WItem) -> URL {
        let width: Int? = item.width != nil ? Int(item.width! * Constants.scale) : nil
        let height: Int? = item.height != nil ? Int(item.height! * Constants.scale) : nil
        return self.urlHandler.handle(url: item.url, width: width, height: height)
    }
    
    private func updateItem(item:  WItem,
                            width: WPlatformFloat?,
                            height: WPlatformFloat?,
                            priority: Priority?,
                            resetOther: Bool) {
        if resetOther {
            item.width = width ?? 0 > 0 ? width : nil
            item.height = height ?? 0 > 0 ? height : nil
            item.priority =  priority ?? .normal
        } else {
            if width != nil {
                item.width = width ?? 0 > 0 ? width : nil
            }
            if height != nil {
                item.height = height ?? 0 > 0 ? height : nil
            }
            item.priority = priority ?? item.priority
        }
        
    }
    
    private func loadItem(item:  WItem) {
        let url = self.makeUrl(item: item)
        if let image = self.storageHanler.getImage(url: url) {
            item.completion?(image)
            return
        }
        self.download(url: url, id: item.id, completion: item.completion)
    }
    
    private func download(url:  URL, id: UInt, completion: WCompletion?) {
        self.loadingLocker.lock()
        let loading = self.loadingItems[url] != nil
        if loading {
            self.loadingItems[url]?[id] = completion
            self.loadingLocker.unlock()
            return
        }
        self.loadingItems[url] = [id : completion]
        self.loadingLocker.unlock()
        self.networkHandler.load(url: url, completion: { url, image, data, error, count in
            self.downloaded(url: url, image: image, data: data, erro: error, count: count)
        })
        
        
    }
    
    private func downloaded(url: URL, image: WPlatformImage?, data: Data?, erro: Error?, count: Int) {
        if let image = image, let data = data {
            self.storageHanler.saveImage(url: url, image: image, imageData: data)
        }
        DispatchQueue.main.async {
            self.loadingLocker.lock()
            self.loadingItems[url]?.values.forEach({ completion in
                completion?(image)
            })
            self.loadingItems[url] = nil
            self.loadingLocker.unlock()
        }
    }
}

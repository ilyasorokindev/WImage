import Foundation

public class WImage {
    public static let shared = WImage()
    
    private let counterLocker = NSLock()
    private var handler: WImageHandlerProtocol = WImageHandler()
    private var counter: UInt = 0
    
    private init() {
    }
    
    public func setHandler(handler: WImageHandlerProtocol) -> WImage {
        self.handler = handler
        return self
    }
    
    public func load(url: URL,
                     completion: WCompletion?,
                     width: Int? = nil,
                     height: Int? = nil,
                     priority: Priority = .normal) -> WItem {
        self.counterLocker.lock()
        self.counter += 1
        let item = WItem(id: self.counter,
                         url: url,
                         completion: completion,
                         width: width ?? 0 > 0 ? width : nil,
                         height: height ?? 0 > 0 ? height : nil)
        self.counterLocker.unlock()
    }
    
    
    public func update(item:  WItem,
                       width: Int? = nil,
                       height: Int? = nil,
                       priority: Priority? = nil,
                       resetOther: Bool = false) {
        self.cancel(item: item)
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
    
    public func cancel(item:  WItem) {
        let url = self.handler.handle(item: item)
        
    }
    
}

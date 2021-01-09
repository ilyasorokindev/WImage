//
//  File.swift
//  
//
//  Created by Ilya Sorokin on 07.11.2020.
//

import Foundation

public protocol WStorageHandlerProtocol {

    func getImage(url: URL) -> WPlatformImage?
    func saveImage(url: URL, image: WPlatformImage, imageData: Data)
    func removeImage(url: URL)
    func removeAllImages()
}

internal class WStorageHandler: WStorageHandlerProtocol {

    private let fileManager = FileManager.default
    private let documentDirectoryUrl: URL = {
      do {
        let fileManager = FileManager.default
        let url = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(Constants.cacheName, isDirectory: true)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
      } catch {
        fatalError("can not get documentDirectoryUrl")
      }
    }()

    func getImage(url: URL) -> WPlatformImage? {
        let fileUrl = self.makeFileUrl(url: url)
        if let data = try? Data(contentsOf: fileUrl) {
            return WPlatformImage(data: data, scale: Constants.scale)
        }
        return nil
    }

    func saveImage(url: URL, image: WPlatformImage, imageData: Data) {
        let fileUrl = self.makeFileUrl(url: url)
        do {
          try imageData.write(to: fileUrl)
        } catch {
          assertionFailure("Can not save file \(fileUrl.absoluteString)")
        }
    }

    func removeImage(url: URL) {
        let fileUrl = self.makeFileUrl(url: url)
      try? FileManager.default.removeItem(at: fileUrl)
    }

    func removeAllImages() {
        DispatchQueue.global().async {
          do {
            try self.fileManager.contentsOfDirectory(at: self.documentDirectoryUrl,
                                                includingPropertiesForKeys: nil,
                                                options: [])
              .forEach({ url in
                try self.fileManager.removeItem(at: url)
              })
          } catch {
            assertionFailure(error.localizedDescription)
          }
        }
    }

    private func makeFileUrl(url: URL) -> URL {
        let name = Data(url.absoluteString.utf8).base64EncodedString().replacingOccurrences(of: "/", with: "")
        return documentDirectoryUrl.appendingPathComponent(name, isDirectory: false)
      }

}

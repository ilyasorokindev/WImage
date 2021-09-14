//
//  AppDelegate.swift
//  WImageExample
//
//  Created by Ilya Sorokin on 09.11.2020.
//

import UIKit
import WImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        WImage.shared.setURLHandler(urlHandler: self)
        WImage.shared.load(path: Constants.url1, priority: .low)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: WURLHandlerProtocol {

    func handle(path: String, width: Int?, height: Int?, filter: Int?) -> URL? {
        guard let url = URL(string: path) else {
            fatalError("Incorrect URL")
        }
        guard let width = width else {
          return url
        }
        if let height = height {
          let newUrlString = url.absoluteString.replacingOccurrences(of: "/100x100/", with: "/\(width)x\(height)/").replacingOccurrences(of: "/100/100/", with: "/\(width)/\(height)/")
          return URL(string: newUrlString)!
        }
        let newUrlString = url.absoluteString.replacingOccurrences(of: "/100x100/", with: "/\(width)/")
        return URL(string: newUrlString)!
    }

}

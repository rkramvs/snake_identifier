//
//  AppDelegate.swift
//  Snake Indentifier
//
//  Created by Ram Kumar on 02/07/25.
//


import SwiftUI
import Analytics
import InAppRating
import PurchaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      Firebase.configure()
      PurchaseManager.shared.setup(revenueCatAPIKey: RevenueCatConstants.apiKey,
                                   delegate: PurchaseManagerHelper.shared,
                                   defaults: appGroupStore!)
      UITextView.appearance().backgroundColor = UIColor.secondarySystemBackground
      InAppRatingController.shared.setup(appGroup: AppConstants.appGroup)
//      UNUserNotificationCenter.current().delegate = NotificationManagerWrapper.shared
      
    return true
  }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem,
           let type = AppShortcutItemType(rawValue: shortcutItem.type) {
            AppShortCutItemModelWrapper.shared.model.item = type
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomSceneDelegate.self
        return sceneConfiguration
    }
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let type = AppShortcutItemType(rawValue: shortcutItem.type) {
            AppShortCutItemModelWrapper.shared.model.item = type
        }
    }
}

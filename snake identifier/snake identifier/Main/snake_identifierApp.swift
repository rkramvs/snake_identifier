//
//  snake_identifierApp.swift
//  snake identifier
//
//  Created by Ram Kumar on 31/07/25.
//

import SwiftUI
import UIComponents

@main
struct snake_identifierApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    @StateObject var appShortcutWrapper: AppShortCutItemModelWrapper = AppShortCutItemModelWrapper.shared

    var body: some Scene {
        WindowGroup {
            AlertWrapper {
                AppShortcutWrapper(appShortCutItemModel: $appShortcutWrapper.model) {
                    RootView()
                        .wrappingInsideMail()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(Defaults.shared)
                }
            }
        }
    }
}

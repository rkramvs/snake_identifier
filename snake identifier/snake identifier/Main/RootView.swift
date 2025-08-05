//
//  RootView.swift
//  Snake identifier
//
//  Created by Ram Kumar on 10/07/25.
//


import SwiftUI
import CoreData
import PurchaseUI
import PurchaseCore
import UIComponents

struct RootView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var mail: MailModelWrapper

    @EnvironmentObject var defaults: Defaults
    @StateObject var purchaseManager: PurchaseManager = PurchaseManager.shared
    @State var tab: Tab = .snake
    
    var body: some View {
        if defaults.isOnboardCompleted {
            TabBarView(selectedTab: $tab)
                .paywallWrapper()
                .appShortCutAction{ type in
                    shortCutItemHandler(type)
                }
        } else {
            OnboardView()
        }
    }
    
    func shortCutItemHandler(_ item: AppShortcutItemType) {
        switch item {
        case .support:
            mail.model = MailModel(toMail: AppConstants.toMail,
                                   subject: String(localized: "Snake Identifier Feedback"),
                                   body: "",
                                   info: AppConstants.mailBody(purchase: purchaseManager))
        case .review:
            openURL(URL(string: AppConstants.appStoreReviewURLString)!)
        }
    }
}

public extension View {
    func paywallWrapper() -> some View {
        PaywallWrapper(appStoreURL: URL(string: AppConstants.appStoreURLString)!,
                       appStoreReviewURL: URL(string: AppConstants.appStoreReviewURLString)!,
                       content: {
            self
        }, paywall: {
            RevenueCatPaywallView {
                PurchaseManager.shared.shownPaywall = false
            }
        })
    }
}

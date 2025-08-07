//
//  SettingsView.swift
//  Snake identifier
//
//  Created by Ram Kumar on 12/11/24.
//


import Foundation
import SwiftUI
import UIKit
import MessageUI
import Haptic
import UIUtility
import UIComponents
import UtilityKit
import PurchaseCore
import Analytics
import InAppRating
import Localisation

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var mail: MailModelWrapper
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var alert: AlertModelWrapper
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var defaults: Defaults

    @State var isRestoringInProgress: Bool = false
    @State private var isShareSheetPresented = false
   
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                        SettingsRowHInfoView(title: "Language",
                                             info: (Language(rawValue: Bundle.main.preferredLocalizations.first ?? "") ?? .english).localisedTitle,
                                             systemSymbol: "globe",
                                             titleDecorator: AppDecorators.primaryTextDecorator)
                        .modifier(DisclosureModifier(decorator: Decorators.settingsRowDisclosure))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            Haptic.impact(.light).generate()
                            LocalisationHelper.openSettings()
                        }
                }
                
                Section(header: Text("Subscription").decorator(TextDecorator(font: .subheadline, fontDesign: .rounded, fontWeight: .semibold))) {
                    if let isPROUser = purchase.isPurchasedUser,  !isPROUser{
                        SettingsRowView(title: "Upgrade to Pro Version",
                                        systemSymbol: "crown.fill",
                                        titleDecorator: AppDecorators.primaryTextDecorator)
                        .onTapGesture {
                            AnalyticsManager.logEvent(.SettingsPurchase)
                            purchase.shownPaywall = true
                        }
                    }
                    
                    SettingsRowView(title: "Restore Purchase",
                                    systemSymbol: "arrow.clockwise.circle.fill",
                                    titleDecorator: AppDecorators.primaryTextDecorator)
                    .onTapGesture {
                        AnalyticsManager.logEvent(.SettingsPurchaseRestore)
                        restorePurchase()
                    }
                }
                
                
                Section(header: Text("Support").decorator(TextDecorator(font: .subheadline, fontDesign: .rounded, fontWeight: .semibold))) {
                    
                    
                    SettingsRowView(title: "Email Developer",
                                    systemSymbol: "envelope",
                                    titleDecorator: AppDecorators.primaryTextDecorator)
                    .onTapGesture {
                        AnalyticsManager.logEvent(.SettingsSuggestFunction)
                        mail.model = MailModel(toMail: AppConstants.toMail,
                                               subject: "Snake AI Support",
                                               body: "",
                                               info: AppConstants.mailBody(purchase: purchase))
                    }
                    
                    SettingsRowView(title: "Review the Application",
                                    systemSymbol: "star.fill",
                                    titleDecorator: AppDecorators.primaryTextDecorator,
                                    iconDecorator: ImageDecorator(foregroundColor: Color(uiColor: .systemYellow), backgroundColor: .accentColor))
                    .onTapGesture {
                        AnalyticsManager.logEvent(.SettingsReviewTheApp)
                        openURL(URL(string: AppConstants.appStoreReviewURLString)!)
                    }
                    
                    
                    SettingsRowView(title: "Share The App",
                                    systemSymbol: "square.and.arrow.up.fill",
                                    titleDecorator: AppDecorators.primaryTextDecorator)
                    .onTapGesture {
                        AnalyticsManager.logEvent(.ShareTheApp)
                        isShareSheetPresented = true
                    }
                }
                
                
                Section(header: Text("Legal").decorator(TextDecorator(font: .subheadline, fontDesign: .rounded, fontWeight: .semibold))) {
                    
                    SettingsRowView(title: "Terms of Service",
                                    systemSymbol: "doc.text.fill",
                                    titleDecorator: AppDecorators.primaryTextDecorator)
                    .onTapGesture {
                        AnalyticsManager.logEvent(.TermsSettings)
                        openURL(URL(string: AppConstants.termsURLString)!)
                    }
                    
                    
                    SettingsRowView(title: "Privacy Policy",
                                    systemSymbol: "shield.fill",
                                    titleDecorator: AppDecorators.primaryTextDecorator)
                    .onTapGesture {
                        AnalyticsManager.logEvent(.PolicySettings)
                        openURL(URL(string: AppConstants.privacyURLString)!)
                    }
                    
                }
                
                OtherAppsSection(otherApps: [.tallyCounter, .smartReceipts, .ringSizer, .quitSmoke, .countryTracker, .chartAI, .fishId, .vegId, .seedId, .seaShellId], tapHandler: {app in
                    AnalyticsManager.logLeadEvent(app)
                })
                
                Section(header: Text("About").decorator(TextDecorator(font: .subheadline, fontDesign: .rounded, fontWeight: .semibold))) {
                    SettingsRowHInfoView(title: "App Version",
                                         info: AppConstants.currentVersion,
                                         systemSymbol: "info.circle.fill",
                                         titleDecorator: AppDecorators.primaryTextDecorator)
                }
                
                Section {
                    Spacer()
                        .frame(height: 60)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .overlay{
                if isRestoringInProgress {
                    LoadingView(title: "Restoring purchase...")
                }
            }
            .navigationTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    ContactButton()
                }
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(items: ["Check out this amazing app!", URL(string: AppConstants.appStoreURLString)!])
            }
        }
    }
    
    func restorePurchase() {
        isRestoringInProgress = true
        Task {
            do {
                try await purchase.restorePurchases()
                isRestoringInProgress = false
            }catch  {
                isRestoringInProgress = false
                alert.model = AlertModel(title: "Restore Purchase", message: error.localizedDescription)
            }
        }
    }
}


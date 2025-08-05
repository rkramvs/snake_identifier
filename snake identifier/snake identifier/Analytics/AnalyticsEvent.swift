//
//  AnalyticsEvent.swift
//  Snake identifier
//
//  Created by Ram Kumar on 11/11/24.
//


import Foundation
import Analytics

//TODO: Add Events

enum AnalyticsEvent: String, EvenRepresentable {
    
    var description: String { return self.rawValue }
    
    case OnboardIdentify
    case OnboardDiscover
    case OnboardDetailContinue
    case OnboardPaywallContinue
    
    case OnboardRatingStar1
    case OnboardRatingStar2
    case OnboardRatingStar3
    case OnboardRatingStar4
    case OnboardRatingStar5
    
    case ScanViaCamera
    case ScanViaPhoto
    case ScanViaFiles
    
    case SnakeIdentified
    
    case SnakeAIChatOpenInDetail
    case SnakeAIChatOpenInList
    
    case SettingsPurchase
    case SettingsPurchaseRestore
    case SettingsRateTheApp
    case SettingsReviewTheApp
    case SettingsSuggestFunction
    case SettingsReportProblem
    case ShareTheApp
    case TermsSettings
    case PolicySettings
    
}


extension AnalyticsManager {
    static func logEvent(_ event: AnalyticsEvent, params: [String: Any]? = nil) {
        AnalyticsManager.shared.logEvent(event: event, params: params)
    }
}

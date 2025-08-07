//
//  AnalyticsEvent.swift
//  Snake identifier
//
//  Created by Ram Kumar on 11/11/24.
//


import Foundation
import Analytics
import UIComponents

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
    
    case PasswordManagerLead
    case HabitBreakerLead
    case TallyCounterLead
    case CountryTrackerLead
    case SmartReceiptsLead
    case ExpenseReportLead
    case RingSizerLead
    case TimeLeftLead
    case QuitSmokeLead
    case BeenTogetherLead
    case ChartAILead
    case PoopCounterLead
    case CouplesQuestionsLead
    
    case InsectIdLead
    case RockIdLead
    case CoinIdLead
    case SeaShellIdLead
    case VegIdLead
    case FishIdLead
    case SeedIdLead
    case SnakeIdLead
    case GrassIdLead
    case HowMuchLead
    case CatIdLead
    
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
    
    
    static func logLeadEvent(_ app: RekuApps) {
        switch app {
            
        case .passwordManager:
            logEvent(AnalyticsEvent.PasswordManagerLead)
        case .habitBreaker:
            logEvent(AnalyticsEvent.HabitBreakerLead)
        case .tallyCounter:
            logEvent(AnalyticsEvent.TallyCounterLead)
        case .countryTracker:
            logEvent(AnalyticsEvent.CountryTrackerLead)
        case .smartReceipts:
            logEvent(AnalyticsEvent.SmartReceiptsLead)
        case .expenseReport:
            logEvent(AnalyticsEvent.ExpenseReportLead)
        case .ringSizer:
            logEvent(AnalyticsEvent.RingSizerLead)
        case .timeLeft:
            logEvent(AnalyticsEvent.TimeLeftLead)
        case .quitSmoke:
            logEvent(AnalyticsEvent.QuitSmokeLead)
        case .beenTogether:
            logEvent(AnalyticsEvent.BeenTogetherLead)
        case .chartAI:
            logEvent(AnalyticsEvent.ChartAILead)
        case .poopCounter:
            logEvent(AnalyticsEvent.PoopCounterLead)
        case .couplesQuestions:
            logEvent(AnalyticsEvent.CouplesQuestionsLead)
        case .insectId:
            logEvent(AnalyticsEvent.InsectIdLead)
        case .rockId:
            logEvent(AnalyticsEvent.RockIdLead)
        case .coinId:
            logEvent(AnalyticsEvent.CoinIdLead)
        case .seaShellId:
            logEvent(AnalyticsEvent.SeaShellIdLead)
        case .vegId:
            logEvent(AnalyticsEvent.VegIdLead)
        case .fishId:
            logEvent(AnalyticsEvent.FishIdLead)
        case .seedId:
            logEvent(AnalyticsEvent.SeedIdLead)
        case .snakeId:
            logEvent(AnalyticsEvent.SnakeIdLead)
        case .grassId:
            logEvent(AnalyticsEvent.GrassIdLead)
        case .howMuch:
            logEvent(AnalyticsEvent.HowMuchLead)
        case .catId:
            logEvent(AnalyticsEvent.CatIdLead)
        }
       
    }
    
    
}

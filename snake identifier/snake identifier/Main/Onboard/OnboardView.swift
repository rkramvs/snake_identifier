//
//  OnboardingTab.swift
//  Snake Indentifier
//
//  Created by Ram Kumar on 02/07/25.
//



import SwiftUI
import Haptic
import UIUtility
import UIComponents
import IdentifierScanner
import InAppRating
import Analytics
import PurchaseUI
import CoreData

enum OnboardingTab: Int, OnboardingTabRepresentable {
    
    typealias RawValue = Int
    
    case info, rating, sampleImage, identifying, detail, paywall
    
    func next() -> OnboardingTab? {
        switch self {
        case .info:
            return .sampleImage
        case .sampleImage:
            return .identifying
        case .identifying:
            return .detail
        case .detail:
            return .paywall
        case .paywall:
            return .rating
        case .rating:
            return nil
        }
    }
    
    func view(selectedTab: Binding<OnboardingTab>, viewContext: NSManagedObjectContext) -> some View {
        switch self {
        case .info:
            return AnyView(OnboardingInfoView(
                selectedTab: selectedTab,
                model: OnboardingInfoModel(
                    icon: Image(.applaunch),
                    title: "Get Started with Snake ID",
                    subtitle: "Your smart tool to identify snake species instantly. Ideal for nature lovers, hikers, and wildlife enthusiasts — now in multiple languages.",
                    infos: [
                        OnboardInfoRowModel(title: "Snap & Identify Instantly",
                                            subTitle: "Just take a photo — we’ll identify the snake with AI.",
                                            symbolsImage: Image(systemName: "camera.viewfinder")),
                        OnboardInfoRowModel(title: "Learn & Stay Safe",
                                            subTitle: "Discover detailed info like venom level, habitat, and behavior.",
                                            symbolsImage: Image(systemName: "book.closed")),
                        OnboardInfoRowModel(title: "Save Your Sightings",
                                            subTitle: "Keep a history of identified snakes and revisit them anytime.",
                                            symbolsImage: Image(systemName: "bookmark.square")),
                        OnboardInfoRowModel(title: "Multi-language Support",
                                            subTitle: "Use the app in your preferred language — no barriers, just knowledge.",
                                            symbolsImage: Image(systemName: "globe"))
                    ]
                ), handler: {
                    AnalyticsManager.logEvent(.OnboardIdentify)
                }))
        case .rating:
            return AnyView(
                OnboardRatingView(
                    selectedTab: selectedTab,
                    handler: {rating in
                        switch rating {
                        case 1:
                            AnalyticsManager.logEvent(.OnboardRatingStar1)
                        case 2:
                            AnalyticsManager.logEvent(.OnboardRatingStar2)
                        case 3:
                            AnalyticsManager.logEvent(.OnboardRatingStar3)
                        case 4:
                            AnalyticsManager.logEvent(.OnboardRatingStar4)
                        case 5:
                            AnalyticsManager.logEvent(.OnboardRatingStar4)
                        default:
                            break
                        }
                        SnakeMObject(context: viewContext).extract(from:  OnboardModel.model, context: viewContext)
                        try? viewContext.save()
                        Defaults.shared.isOnboardCompleted = true
                    }))
        case .sampleImage:
            return AnyView(OnboardSampleImageView(
                model: OnboardSampleImageModel(
                    title: "Curious about this snake?",
                    subTitle: "Tap below to see what species it is — instantly with AI.",
                    onboardImage: Image(.onboardSnake)),
                selectedTab: selectedTab,
                handler: {
                    AnalyticsManager.logEvent(.OnboardDiscover)
                }
            ))
        case .identifying:
            return AnyView(OnboardIdentifyingView(
                model: OnboardIdentifyingModel(image: UIImage(named: "onboard_snake"),
                                               footerText: String(localized: "Hang tight! We’re identifying your snake with AI magic"),
                                               loadingTexts: [
                                                String(localized: "Analyzing texture"),
                                                String(localized: "Detecting color patterns"),
                                                String(localized: "Matching with snake database"),
                                                String(localized: "AI confirming identity"),
                                               ]),
                selectedTab: selectedTab, handler: {
                    
                }
            ))
        case .detail:
            return AnyView(OnboardDetailView(
                selectedTab: selectedTab,
                baseView:  { return AnyView(SnakeDetailBaseView(model: OnboardModel.model)) },
                handler: {
                    AnalyticsManager.logEvent(.OnboardDetailContinue)
                }
            ))
        case .paywall:
            return AnyView(OnboardPaywallView(
                selectedTab: selectedTab,
                handler: {
                    AnalyticsManager.logEvent(.OnboardPaywallContinue)
                }))
        }
    }
}

struct OnboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedTab: OnboardingTab = .info
    @State private var offset: CGFloat = 0
    var body: some View {
        selectedTab.view(selectedTab: $selectedTab, viewContext: viewContext)
            .tag(selectedTab)
    }
}

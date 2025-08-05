//
//  SnakeListView.swift
//  snake identifier
//
//  Created by Ram Kumar on 02/08/25.
//


import SwiftUI
import CoreData
import AIProxy
import IdentifierScanner
import UIComponents
import Haptic
import UIUtility
import PurchaseCore
import InAppRating
import Analytics

struct SnakeListView: View {
    @EnvironmentObject var purchase: PurchaseManager
    @EnvironmentObject var defaults: Defaults
    @Namespace private var namespace
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var scannerViewModel: IdentifierScannerWrapperViewModel<SnakeModel> = IdentifierScannerWrapperViewModel<SnakeModel>(
        configuration: AIConfiguration(partialKey: AppConstants.OpenAIServiceConstants.partialKey,
                                       serviceURL: AppConstants.OpenAIServiceConstants.serviceURL),
        prompt: AppConstants.OpenAIServiceConstants.prompt,
        schema: AppConstants.OpenAIServiceConstants.snakeIdentifierSchema,
        texts: IdentifierScanPreviewTexts(
            footerText: String(localized: "Hang tight! We’re identifying your snake with AI magic"),
            loadingTexts: [
                String(localized: "Analyzing texture"),
                String(localized: "Detecting color patterns"),
                String(localized: "Matching with snake database"),
                String(localized: "AI confirming identity"),
            ]))
    
    @State var snakeForDetail: SnakeModel?
    @State var paywallShownOnAppear: Bool = false
    
    var snakeRequest = FetchRequest<SnakeMObject>(
        sortDescriptors: [SortDescriptor(\.lastUpdatedDate, order: .reverse)],
        animation: .default)
    
    var snakes: FetchedResults<SnakeMObject> {
        return snakeRequest.wrappedValue
    }
    
    var body: some View {
        NavigationStack {
            IdentifierScannerWrapper(viewModel: scannerViewModel, content: {
                ZStack(alignment: .bottom) {
                    if snakes.isEmpty {
                        UIElements.emptyView(title: "No Snakes Yet",
                                             subtitle: "Scan a snake to identify it and start building your list!")
                    } else {
                        listView
                    }
                    
                    TransparentBlurView(style: .systemMaterialLight)
                        .blur(radius: 15)
                        .padding([.horizontal, .bottom], -30)
                        .ignoresSafeArea(edges: .bottom)
                        .frame(height: 20)
                    
                    bottomAction
                        .shadow(color: .primary.opacity(0.1), radius: 10)
                        .padding(.bottom, 20)
                }
                
            }, completion: { model in
                scannerViewModel.scannedModel = model
            })
            .onChange(of: scannerViewModel.scannedModel) { oldValue, newValue in
                if let newValue {
                    AnalyticsManager.logEvent(.SnakeIdentified)
                    defaults.snakeScannedCount += 1
                    SnakeMObject(context: viewContext).extract(from: newValue, context: viewContext)
                    try? viewContext.save()
                    snakeForDetail = newValue
                    
                    if !InAppRatingController.shared.reviewPageShownForThisLaunch {
                        InAppRatingController.shared.askRatingForcefully()
                        InAppRatingController.shared.reviewPageShownForThisLaunch = true
                    }
                }
            }
            .navigationTitle("Snakes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ContactButton(color: .primary)
                }
            }
            .navigationDestination(item: $snakeForDetail) { item in
                if #available(iOS 18.0, *) {
                    SnakeDetailView(model: item)
                        .navigationTransition(.zoom(sourceID: item.id, in: namespace))
                } else {
                    SnakeDetailView(model: item)
                }
            }
        }
    }
    
    @ViewBuilder
    var bottomAction: some View {
        Menu {
            ForEach(ScannerOption.allCases, id: \.self) { option in
                UIElements.menuButton(title: option.title, systemImage: option.systemImage) {
                    if let isPROUser = purchase.isPurchasedUser{
                        if isPROUser || defaults.snakeScannedCount < AppConstants.freeSnakeLimit {
                            action(option)
                        } else {
                            purchase.shownPaywall = true
                        }
                    } else {
                        action(option)
                    }
                }
            }
        } label: {
            UIElements.floatingActionButton(systemImage: "viewfinder") {
            }
        }
    }
    
    private func showPaywall() {
        if !paywallShownOnAppear {
            if let isPROUser = purchase.isPurchasedUser,  !isPROUser{
                Haptic.impact(.light).generate()
                purchase.shownPaywall = true
                paywallShownOnAppear = true
            }
        }
    }
    
    private func action(_ option: ScannerOption) {
        switch option {
        case .camera:
            AnalyticsManager.logEvent(.ScanViaCamera)
            self.scannerViewModel.showDocumentScanner.toggle()
        case .photo:
            AnalyticsManager.logEvent(.ScanViaPhoto)
            self.scannerViewModel.showPhotoPicker.toggle()
        case .files:
            AnalyticsManager.logEvent(.ScanViaFiles)
             self.scannerViewModel.showDocumentPicker.toggle()
        }
    }
    
    
    @ViewBuilder
    var listView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16){
                ForEach(snakes, id: \.self) { snake in
                    Group {
                        if #available(iOS 18.0, *) {
                            SnakeContentView(viewModel: SnakeContentVM(model: snake.model))
                                .matchedTransitionSource(id: snake.id, in: namespace)
                        } else {
                            SnakeContentView(viewModel: SnakeContentVM(model: snake.model))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Haptic.impact(.light).generate()
                        snakeForDetail = snake.model
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 200)
        }
    }
}


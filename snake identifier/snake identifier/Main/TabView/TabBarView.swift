//
//  TabBarView.swift
//  Snake identifier
//
//  Created by Ram Kumar on 12/11/24.
//


import SwiftUI
import Haptic
import PurchaseCore
import UIComponents

struct TabBarView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedTab: Tab
 
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) {tab in
                tab.getView(tabItem: $selectedTab)
                    .tabItem {
                        if tab == selectedTab {
                            Image(systemName: tab.selectedSymbolName)
                        } else {
                            Image(systemName: tab.symbolName)
                        }
                        
                        Text(tab.displayText)
                    }
                    .tag(tab)
            }
        }
        .onChange(of: selectedTab) { old, new in
            Haptic.impact(.light).generate()
        }
        .onChange(of: purchaseManager.isPurchasedUser) { oldValue, newValue in
            showPaywall()
        }
    }
    
    private func showPaywall() {
        if let isProUser = purchaseManager.isPurchasedUser, !isProUser {
            purchaseManager.shownPaywall = true
        }
    }
}


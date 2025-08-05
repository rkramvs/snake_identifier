//
//  Tab.swift
//  Snake identifier
//
//  Created by Ram Kumar on 12/11/24.
//


import SwiftUI
import UIComponents

enum Tab: String, CaseIterable, Identifiable {

    var id: String { rawValue }
    
    case snake, collection, settings
}

extension Tab {
    var displayText: LocalizedStringKey {
        switch self {
        case .snake: return "Snake"
        case .collection: return "Collections"
        case .settings: return "Settings"
        }
    }
    
    var symbolName: String {
        switch self {
        case .snake: return "circle"
        case .collection: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var selectedSymbolName: String {
        switch self {
        case .snake: return "circle.fill"
        case .collection: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    
    func getView(tabItem: Binding<Tab>) -> AnyView {
        switch self {
        case .snake:
            return AnyView(SnakeListView())
        case .collection:
            return AnyView(CollectionListView())
        case .settings:
            return AnyView(SettingsView())
        }
    }
}
